package net.just1factory.swiftui_and_redux_example_backend.app.controller.api.v1
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

// MEMO: サンプル用のレスポンス
@RestController
@RequestMapping("/api/v1")
class SampleController {
	@GetMapping("/")
	fun getHello() :String {
		return "Hello World"
	}
}