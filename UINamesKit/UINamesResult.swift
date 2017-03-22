
import Foundation

public enum UINamesResult<T>
{
    case success(result: T)

    case error(message: String)
}
