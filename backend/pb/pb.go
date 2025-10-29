package pb

import (
	"log"

	"github.com/pocketbase/pocketbase"
)

func StartPocketBase() *pocketbase.PocketBase {
	app := pocketbase.New()

	app.RootCmd.SetArgs([]string{
		"serve",
		"--http=127.0.0.1:8090",
	})

	go func() {
		log.Println("▶ PocketBase: 开始启动 (127.0.0.1:8090)")
		if err := app.Start(); err != nil {
			log.Fatalf("错误: %v", err)
		}
	}()

	return app
}
