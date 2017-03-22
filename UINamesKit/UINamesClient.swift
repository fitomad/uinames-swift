import Foundation

/**
	Closure donde devolvemos los resultado
*/
public typealias UINamesCompletionHandler<T> = (_ result: T) -> (Void)

/**
	Aquí recibimos la respuesta del servidor
*/
private typealias HttpCompletionHandler = (_ result: HttpResult) -> (Void)

/**

*/
public class UINamesClient
{
	/// Singleton
	public static let shared: UINamesClient = UINamesClient()

	/// URL de partida para todas las peticion
	private let baseURL: String
	/// La session HTTP...
    private var httpSession: URLSession
    /// ...y su configuracion
    private var httpConfiguration: URLSessionConfiguration

	/**
		Establecemos la URL de base y la
		configuración HTTP
	*/
	private init()
	{
		self.baseURL = "https://uinames.com/api/"

		self.httpConfiguration = URLSessionConfiguration.default
        self.httpConfiguration.httpMaximumConnectionsPerHost = 10

        let http_queue: OperationQueue = OperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = URLSession(configuration:self.httpConfiguration,
                                      delegate:nil,
                                      delegateQueue:http_queue)
	}

	//
	// MARK: - Operations
	//

    /**
		Solicitamos *2 o más personas* al servicio de nombre.

		- Parameters:
			- from: El país de procedencia. Por defecto aleatorio
			- gender: El género del sujeto. Por defecto aleatorio
			- amount: La cantidad de *muñecos* que queremos crear
			- extendedInformation: Si queremos que nos de información como *email* o *tarjeta bancaria*
			- completionHandler: El closure donde lo devolvemos
		- SeeAlso: `person(from:, gender:,extendedInformation:,completionHandler:)`
    */
	public func people(from country: Country = Country.worldwide, gender: Gender = Gender.random, amount: Int = 2, extendedInformation extended: Bool = false, completionHandler: @escaping UINamesCompletionHandler<UINamesResult<[PersonExtended]>>) -> Void
	{
		guard amount > 2 else
		{
			completionHandler(UINamesResult.error(message: "La cantidad de identidades solicitadas debe ser mayor o igual a 2"))
			return
		}

        var uri: String = "\(self.baseURL)?region=\(country.rawValue)&gender=\(gender.rawValue)&amount=\(amount)"

		if extended
		{
			uri += "&ext"
		}

		guard let url = URL(string: uri) else
		{
			completionHandler(UINamesResult.error(message: "Los parámetros no generan un recurso URI válido"))
			return
		}

        self.processHttpRequest(url, httpHandler: { (resultado: HttpResult) -> (Void) in
        	switch resultado
        	{
				case let HttpResult.success(data):
                    if let resultado = try? JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments),
                       let json = resultado as? [[String: Any]],
                       !json.isEmpty
					{
						let people: [PersonExtended] = json.map({
                            guard let person_data = PersonExtended(json: $0) else
                            {
                                return nil
                            }
                            
                            return person_data
                        }).filter({ $0 != nil }) as! [PersonExtended]
                        
                        completionHandler(UINamesResult.success(result: people))
					}
                
                case let HttpResult.requestError(_, message):
                    completionHandler(UINamesResult.error(message: message))

        		case let HttpResult.connectionError(reason):
					completionHandler(UINamesResult.error(message: reason))
        	}
        })
	}

	/**
		Solicitamos una persona al servidor de nombres.

		- Parameters:
			- from: El país de procedencia. Por defecto aleatorio
			- gender: El género del sujeto. Por defecto aleatorio
			- extendedInformation: Si queremos que nos de información como *email* o *tarjeta bancaria*
			- completionHandler: El closure donde lo devolvemos
	*/
	public func person(from country: Country = Country.worldwide, gender: Gender = Gender.random, extendedInformation extended: Bool = false, completionHandler: @escaping UINamesCompletionHandler<UINamesResult<PersonExtended>>) -> Void
	{
		var uri: String = "\(self.baseURL)?region=\(country.rawValue)&gender=\(gender.rawValue)"

		if extended
		{
			uri += "&ext"
		}

		guard let url = URL(string: uri) else
		{
			completionHandler(UINamesResult.error(message: "Los parámetros no generan un recurso URI válido"))
			return
		}

		self.processHttpRequest(url, httpHandler: { (resultado: HttpResult) -> (Void) in
        	switch resultado
        	{
				case let HttpResult.success(data):
                    if let resultado = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments),
                       let json = resultado as? [String: Any],
                       let person = PersonExtended(json: json)
					{
                        completionHandler(UINamesResult.success(result: person))
					}
                
                case let HttpResult.requestError(_, message):
                    completionHandler(UINamesResult.error(message: message))
                
        		case let HttpResult.connectionError(reason):
					completionHandler(UINamesResult.error(message: reason))
        	}
        })
	}

	//
	// MARK: - Private Methods
	//

    /**
		Solicitud HTTP
    */
	private func processHttpRequest(_ url: URL, httpHandler: @escaping HttpCompletionHandler) -> Void
    {
        let request: URLRequest = URLRequest(url: url)

        let data_task: URLSessionDataTask = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error
            {
                httpHandler(HttpResult.connectionError(reason: error.localizedDescription))
            }

            guard let data = data, let http_response = response as? HTTPURLResponse else
            {
                httpHandler(HttpResult.connectionError(reason: NSLocalizedString("HTTP_CONNECTION_ERROR", comment: "")))
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    httpHandler(HttpResult.success(data: data))
                default:
                    let code: Int = http_response.statusCode
                    let message: String = HTTPURLResponse.localizedString(forStatusCode: code)

                    httpHandler(HttpResult.requestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}
