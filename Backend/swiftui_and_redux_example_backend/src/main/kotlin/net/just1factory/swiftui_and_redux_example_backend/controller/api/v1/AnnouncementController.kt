package net.just1factory.swiftui_and_redux_example_backend.controller.api.v1

// Domain層（Service）

// Transfer層（Request・Response）

// Context層（Exception）

// Spring Frameworkのインポート宣言
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

// MEMO: Swagger UIに記載する内容を表示するためのアノテーション
import io.swagger.annotations.Api
import io.swagger.annotations.ApiOperation

@RestController
@RequestMapping("/api/v1")
@Api(description = "アプリ内容に関連するお知らせに関するエンドポイント（※イベント情報告知や最新商品の入荷情報・その他お役立ち情報等を掲載する部分になります。）")
class AnnouncementController {

	@ApiOperation(value = "サンプル", produces = "application/json", notes = "Hello worldを表示する", response = String::class)
	@GetMapping("/sample")
	fun get(): String {
		return "Hello world"
	}
}