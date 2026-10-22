```markdown
# Key System Integration

Protect your premium scripts using the built-in asynchronous key system:

```lua
HexLib:KeySystem({"KEY-ABC-123", "KEY-VIP-999"}, function()
    -- Executed only when a valid key is entered
    print("Key verified successfully!")
end)
