package pb

import (
	"log"

	"github.com/pocketbase/pocketbase"
)

// StartPocketBase 启动 PocketBase 服务（监听在 127.0.0.1:8090）
func StartPocketBase() *pocketbase.PocketBase {
	app := pocketbase.New()

	// 一定要在 Start() 之前设置参数
	app.RootCmd.SetArgs([]string{
		"serve",
		"--http=127.0.0.1:8090",
	})

	go func() {
		log.Println("▶ PocketBase: 开始启动 (127.0.0.1:8090)")

		// 注意这里是 Start() 而不是 Execute()
		log.Println("▶ 即将启动 PocketBase")
		if err := app.Start(); err != nil {
			log.Fatalf("错误: %v", err)
		}
		log.Println("✅ PocketBase 启动成功")
	}()

	return app
}
 