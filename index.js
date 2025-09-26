import express from "express"
import fs from "fs"
import path from "path"
import { fileURLToPath } from "url"

const __filename = fileURLToPath(
    import.meta.url)
const __dirname = path.dirname(__filename)

const app = express()
const PORT = 3000

// โฟลเดอร์เก็บไฟล์
const folderPath = path.join(__dirname, "modules")

// อ่านไฟล์ทั้งหมดในโฟลเดอร์
fs.readdir(folderPath, (err, files) => {
    if (err) {
        console.error("Error reading folder:", err)
        return
    }

    files.forEach(file => {
        const routePath = "/api/" + file

        app.get(routePath, (req, res) => {
            const filePath = path.join(folderPath, file)

            fs.readFile(filePath, "utf8", (err, data) => {
                if (err) {
                    return res.status(500).json({ error: "Error reading file" })
                }

                // ลองตรวจนามสกุลไฟล์เพื่อตั้ง content-type
                if (file.endsWith(".json")) {
                    try {
                        return res.json(JSON.parse(data))
                    } catch {
                        return res.status(500).json({ error: "Invalid JSON" })
                    }
                }

                res.type("text/plain").send(data)
            })

        })

        console.log("Created API:", `http://localhost:${PORT}${routePath}`)
    })
})

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`)
})