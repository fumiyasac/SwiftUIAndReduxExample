package net.just1factory.swiftui_and_redux_example_backend

import springfox.documentation.swagger2.annotations.EnableSwagger2
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import springfox.documentation.builders.ApiInfoBuilder
import springfox.documentation.builders.PathSelectors
import springfox.documentation.service.ApiInfo
import springfox.documentation.spi.DocumentationType
import springfox.documentation.spring.web.plugins.Docket
import springfox.documentation.service.Contact

@Configuration
@EnableSwagger2

// MEMO:
// 下記を参考にSwaggerのボトムアップ・アプローチ（ソースコードからAPI定義所を書き起こす）の設定における参考資料

// 参考1: Kotlinで書かれた事例
// https://programmer.ink/think/springboot-2.x-kotlin-and-swagger-2-generate-api-documents.html
// 参考2: その他Swaggerに関する参考資料（※一部Javaのものも含まれています）
// https://qiita.com/shuhey-fujiwara/items/e3bfd8d6deaaa22d618c
// https://qiita.com/akkino_D-En/items/c28c25a71a7672d11de2
// https://qiita.com/YutaKase6/items/52ea048c5352c77330eb
// https://qiita.com/sugasaki/items/c19821bfe483d45b2415

class Swagger2Config {

	@Bean
	fun createRestApi(): Docket {
		return Docket(DocumentationType.SWAGGER_2)
			.select()
			.paths(PathSelectors.ant("/api/v1/**"))
			.build()
			.useDefaultResponseMessages(false)
			.host("localhost:8080")
			.apiInfo(apiInfo())
	}

	private fun apiInfo(): ApiInfo {
		return ApiInfoBuilder()
			.title("iOS App Example API with Server Side Kotlin & SpringBoot2")
			.description("This is API Mock ServerExamples.")
			.termsOfServiceUrl("https://github.com/fumiyasac/SwiftUIAndReduxExample")
			.contact(Contact("fumiyasac", "https://just1factory.net", "just1factory@gmail.com"))
			.version("1.0.0")
			.build()
	}
}