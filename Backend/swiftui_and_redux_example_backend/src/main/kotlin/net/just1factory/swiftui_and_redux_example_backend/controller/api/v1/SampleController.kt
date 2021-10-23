package net.just1factory.swiftui_and_redux_example_backend.controller.api.v1

// Spring Frameworkのインポート宣言
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.bind.annotation.RequestParam

// MEMO: Swagger UIに記載する内容を表示するためのアノテーション

@RestController
@RequestMapping("/api/v1")
class SampleController {

	@GetMapping("/")
	fun get(): String {
		return "Hello world"
	}
}