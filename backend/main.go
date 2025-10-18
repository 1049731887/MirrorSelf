package main

import (
	"fmt"
    "log"
	"os"
	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	// app.Get("/api", func(c *fiber.Ctx) error {
	// 	return c.SendString("Hello, World!\n")
	// })

	// 输入一个文本参数{"meal": "your_text_here"}，返回已记录{"status": "recorded"}
	app.Post("/api/meal", func(c *fiber.Ctx) error {
		type Request struct {
			Meal string `json:"meal"`
		}
		type Response struct {
			Status string `json:"status"`
		}
		var req Request
		if err := c.BodyParser(&req); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Cannot parse JSON",
			})
		}
		
		log.Printf("Received meal: %s\n", req.Meal)
		// 将 req.Meal 存储到数据库或文件的逻辑
		file, err := os.OpenFile("meals.txt", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
		if err != nil {
			panic(err)
		}
		
		return c.JSON(Response{Status: "recorded"})
	})

	app.Listen(":3001")
}
