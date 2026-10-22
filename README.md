# Hex Scripts UI Library

<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-red.svg" alt="License">
  <img src="https://img.shields.io/badge/Roblox-Luau-blue.svg" alt="Roblox">
  <img src="https://img.shields.io/badge/Status-Active-success.svg" alt="Status">
</p>

A modern, sleek, and highly customizable UI Library for Roblox executors, inspired by Fluent & Kavo UI. Features smooth tweening animations, button sound effects, animated red gradient themes, a built-in key system, and full component support.

---

## ⚡ Quick Loadstring Usage

```lua
local HexLib = loadstring(game:HttpGet("[https://raw.githubusercontent.com/IssacPrada/HexLibrary/main/HexLibrary.lua](https://raw.githubusercontent.com/IssacPrada/HexLibrary/main/HexLibrary.lua)"))()

HexLib:KeySystem({"YOUR-KEY-123"}, function()
    local Window = HexLib:CreateWindow({
        Title = "Hex Scripts",
        SubTitle = "v1.0.0"
    })
    
    local Tab = Window:CreateTab("Main")
    local Section = Tab:CreateSection("Player")
    
    Section:CreateButton("Print Hello", function()
        print("Hello from Hex Scripts!")
    end)
end)
