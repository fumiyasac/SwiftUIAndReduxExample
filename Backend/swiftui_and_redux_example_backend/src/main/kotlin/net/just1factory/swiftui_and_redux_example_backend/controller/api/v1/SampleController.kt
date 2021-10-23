package net.just1factory.swiftui_and_redux_example_backend.controller.api.v1

// Spring Frameworkのインポート宣言
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

// MEMO: Swagger UIに記載する内容を表示するためのアノテーション
import io.swagger.annotations.Api
import io.swagger.annotations.ApiOperation

@RestController
@RequestMapping("/api/v1")
@Api(description = "エンドポイント")
class SampleController {

	@ApiOperation(value = "サンプル", produces = "application/json", notes = "Hello worldを表示する", response = String::class)
	@GetMapping("/sample")
	fun get(): String {
		return "Hello world"
	}
}