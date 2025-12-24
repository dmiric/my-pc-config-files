#Requires AutoHotkey v2.0
; Only work if Path of Exile 2 is the active window
#HotIf WinActive("ahk_exe PathOfExileSteam.exe")

; --- Spacebar functionality ---
;$*Space:: {
;    Send("{Blind}{Space}")
;   KeyWait("Space")
;}

; --- Scroll Wheel Up presses E ---
; WheelUp::Send("e")

; --- Scroll Wheel Down presses F ---
; WheelDown::Send("f")

; -------------------------------------------------------
; PoE Search String Menu (Ctrl+Alt+V) - v2 Optimized
; -------------------------------------------------------

^!v:: {
    ; Create MAPS Sub-menu
    MapsMenu := Menu()
    MapsMenu.Add('ALL MODS: "al mod"', MapsHandler)
    MapsMenu.Add("RARE MOB + RARITY", MapsHandler)
    MapsMenu.Add("PACK SIZE", MapsHandler)
    MapsMenu.Add("PACK SIZE (ALT)", MapsHandler)
    MapsMenu.Add("PACK SIZE + RARITY", MapsHandler)
    MapsMenu.Add("HIGH RARITY SELL", MapsHandler)

    ; Create TABLETS Sub-menu
    TabletsMenu := Menu()
    TabletsMenu.Add("Basic: Gold Found", TabletsHandler)
    TabletsMenu.Add("Basic: +1 Rogue Exile", TabletsHandler)
    TabletsMenu.Add("Basic: Experience", TabletsHandler)
    TabletsMenu.Add("Basic: Effectiveness", TabletsHandler)
    TabletsMenu.Add("Basic: Rarity", TabletsHandler)
    TabletsMenu.Add("Basic: Pack Size", TabletsHandler)
    TabletsMenu.Add("Basic: Magic Mobs", TabletsHandler)
    TabletsMenu.Add("Basic: Rare Mobs", TabletsHandler)
    TabletsMenu.Add("Ritual: Defer + Tribute", TabletsHandler)
    TabletsMenu.Add("Breach: FULL", TabletsHandler)
    TabletsMenu.Add("Breach: Splinter only", TabletsHandler)
    TabletsMenu.Add("Abyss: SALE", TabletsHandler)
    TabletsMenu.Add("Expedition: Logbooks", TabletsHandler)
    TabletsMenu.Add("Delirium: Splinters/Unique", TabletsHandler)
    TabletsMenu.Add("Extra Waystones", TabletsHandler)

    ; Create Main Menu
    MyMenu := Menu()
    MyMenu.Add("MAPS", MapsMenu)
    MyMenu.Add("TABLETS", TabletsMenu)
    MyMenu.Add() ; Separator
    MyMenu.Add("PriceMice Logo", LogoHandler)
    MyMenu.Show()
}

MapsHandler(ItemName, ItemPos, MyMenu) {
    if (ItemPos = 1) 
        SendText '"al mod"'
    else if (ItemPos = 2)
        SendText '"r.+s: \+([4-9].|1..)%" "i.+ty: \+([3-9].|1..)%"'
    else if (ItemPos = 3)
        SendText '"m.+e: \+(4[2-9]|[5-9].|1..)%"'
    else if (ItemPos = 4)
        SendText '"m.+e: \+([3-9].|1..)%"'
    else if (ItemPos = 5)
        SendText '"m.+e: \+([2-9].|1..)%" "i.+ty: \+([4-9].|1..)%"'
    else if (ItemPos = 6)
        SendText '"i.+ty: \+([7-9].|1..)%"'
}

TabletsHandler(ItemName, ItemPos, MyMenu) {
    switch ItemPos {
        case 1: SendText '"gold found"'
        case 2: SendText '"al ro"'
        case 3: SendText '(1[5-9]|2.)%.+exp'
        case 4: SendText '(9|1.)%.+ef'
        case 5: SendText '(2[2-9]|30)%.+rari'
        case 6: SendText '(8|9|10)%.+pa'
        case 7: SendText '(6.|70)%.+ma'
        case 8: SendText '(3[3-9]|40)%.+rare'
        case 9: SendText '(2[5-9]|30)%.+red|t (2[5-9]|30)%.+sed t|al ti'
        case 10: SendText '(2[5-9]|30)%.+qua|[1|2].+re mo|al bre'
        case 11: SendText '(2[5-9]|30)%.+qua'
        case 12: SendText 'ur ad|ed fro'
        case 13: SendText '(2[1-9]|30)%.+logbooks'
        case 14: SendText '(2[1-9]|30)%.+um splin|(2[1-9]|30)%.+awn uni'
        case 15: SendText '(4[1-9]|50)%.+waystones'
    }
}

LogoHandler(*) {
    ; Added only one PriceMice logo as requested
    SendText "PriceMice"
}

#HotIf ; Reset hotkey context