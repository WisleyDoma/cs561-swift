import Alamofire
import MyLibrary

// class MockWeatherService: WeatherService {
//    private var shouldSucceed: Bool
//    private var shouldReturnTemperatureWithAnEight: Bool
//
//    init(shouldSucceed: Bool, shouldReturnTemperatureWithAnEight: Bool) {
//        self.shouldSucceed = shouldSucceed
//        self.shouldReturnTemperatureWithAnEight = shouldReturnTemperatureWithAnEight
//    }
//
//    func getTemperature(completion: @escaping (_ response: Result<Int /* Temperature */, Error>) -> Void) {
//        switch (shouldSucceed, shouldReturnTemperatureWithAnEight) {
//        case (true, true):
//            let temperatureInFarenheit = 38
//            completion(.success(temperatureInFarenheit))
//
//        case (true, false):
//            let temperatureInFarenheit = 39
//            completion(.success(temperatureInFarenheit))
//
//        case (false, _):
//            let error404 = AFError.explicitlyCancelled
//            completion(.failure(error404))
//        }
//    }
//}

public protocol WeatherService {
    func getWeather(completionHandler: @escaping (_ response: Result <Int /*Hello string line*/, Error>) -> Void)
    func getHello(completionHandler: @escaping (_ response: Result <String /*Hello string line*/, Error>) -> Void)
    func fetchToken(completionHandler: @escaping (_ response: Result <String /* Token & expr date */, Error>) -> Void)
}

class WeatherServiceImpl: WeatherService {
    let weather_url = "http://localhost:3000/v1/weather"
    let hello_url = "http://localhost:3000/v1/hello"
    let token_url = "http://localhost:3000/v1/auth"
    // function of v1/weather
    func getWeather(completionHandler: @escaping (_ response: Result <Int /*Hello string line*/, Error>) -> Void){
        fetchToken(completionHandler: { response in
            switch response {
            case .failure(let error):
                completionHandler(.failure(error))
                // print("error: \(error)")
                // break
            case .success(let my_token):
                let token_headers : HTTPHeaders = [.authorization(bearerToken: my_token), .accept("application/json")]
                // completionHandler(.success(my_token))
                // print(my_token)
                // break
                //
                    AF.request(self.weather_url, method: .get, headers: token_headers).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                                    switch response.result{
                                    case .success(let weather):
                                        let temperature = weather.main.temp
                                        let temperatureAsInteger = Int(temperature)
                                        completionHandler(.success(temperatureAsInteger))
                                    case .failure(let error):
                                        completionHandler(.failure(error))
                                    }
                        }
                }
        }
        )
    }
    // function of v1/hello
    func getHello(completionHandler: @escaping (_ response: Result <String /*Hello string line*/, Error>) -> Void){
        //
        fetchToken(completionHandler: { response in
            switch response {
            case .failure(let error):
                completionHandler(.failure(error))
                // print("error: \(error)")
                // break
            case .success(let my_token):
                let token_headers : HTTPHeaders = [.authorization(bearerToken: my_token), .accept("application/json")]
                // completionHandler(.success(my_token))
                // print(my_token)
                // break
                //
                AF.request(self.hello_url, method: .get, headers: token_headers).validate(statusCode: 200..<300).responseDecodable(of: Hello.self) { response in
                            switch response.result{
                            case .success(let her_hello):
                                completionHandler(.success(her_hello.message))
                                // print(her_hello)
                                // break
                            case .failure(let ghost):
                                completionHandler(.failure(ghost))
                                // print("error: \(ghost)")
                                // break
                            }
                        }
                }
        }
        )
    }
    let payload = Payload(
      username: "Ricardo",
      password: "o2LAJH12Y2!kq1dA")
    // function of v1/auth
    func fetchToken(completionHandler: @escaping (_ response: Result <String /* Token & expr date */, Error>) -> Void){
        //
        AF.request(token_url, method: .post, parameters: payload, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: Authentication.self){ response in
            switch response.result {
            case .success(let my_token):
                completionHandler(.success(my_token.token))
                // print(my_token)
                // break
            case .failure(let error):
                completionHandler(.failure(error))
                // print("error: \(error)")
                // break
            }
        }
    }
}

// constructors:
private struct Weather: Decodable {
    let main: Main
    
    struct Main: Decodable {
        let temp: Double
    }
}

struct Hello: Codable {
    let message: String
}

// Codable: make the JSON decodable & codable here.
struct Authentication: Decodable{
    var token, expiration_date: String
    
    enum CodingKeys: String, CodingKey {
            case token = "access-token"
            case expiration_date = "expires"
        }
}

// constructor for user inputs
struct Payload: Encodable {
  let username: String
  let password: String
}

// The message shouldn't be mutable, instead I'll use let type.
struct Display_message: Decodable{
    let message: String
}
