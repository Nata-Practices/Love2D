local L = {
    { ability = nil },
    { ability = "doubleJump" },
    { ability = "dash" },
    { ability = "wallJump" },
    { ability = "glide" },
    { ability = "push" },
    { ability = "shield" },
    { ability = "teleport" },
    { ability = "speed" },
    { ability = "groundPound" },
}

L[1].platforms = {
    { x = 0, y = 500, w = 240, h = 100 },
    { x = 320, y = 500, w = 480, h = 100 },
    { x = 320, y = 440, w = 140, h = 20 },
    { x = 420, y = 440, w = 20, h = 60 },
}
L[1].flag = { x = 720, y = 460, w = 20, h = 40 }
L[1].boxes = {}
L[1].turrets = {}

L[2].platforms = {
    { x = 0, y = 500, w = 350, h = 100 },
    { x = 700, y = 500, w = 50, h = 20 },
    { x = 320, y = 370, w = 20, h = 130 },
    { x = 480, y = 300, w = 120, h = 20 },
}
L[2].flag = { x = 740, y = 460, w = 20, h = 40 }
L[2].boxes = {}
L[2].turrets = {}

L[3].platforms = {
    { x = 0, y = 500, w = 250, h = 100 },
    { x = 620, y = 500, w = 250, h = 100 },
    { x = 620, y = 380, w = 120, h = 20 },
}
L[3].flag = { x = 720, y = 460, w = 20, h = 40 }
L[3].boxes = {}
L[3].turrets = {}

L[4].platforms = {
    { x = 0, y = 500, w = 800, h = 100 },
    { x = 100, y = 300, w = 20, h = 190 },
    { x = 200, y = 200, w = 20, h = 300 },
    { x = 300, y = 400, w = 160, h = 20 },
    { x = 640, y = 300, w = 100, h = 20 },
}
L[4].flag = { x = 700, y = 260, w = 20, h = 40 }
L[4].boxes = {}
L[4].turrets = {}

L[5].platforms = {
    { x = 0, y = 500, w = 150, h = 100 },
    { x = 700, y = 500, w = 50, h = 20 },
    { x = 120, y = 370, w = 20, h = 130 },
}
L[5].flag = { x = 740, y = 460, w = 20, h = 40 }
L[5].boxes = {}
L[5].turrets = {}

L[6].platforms = {
    { x = 0, y = 500, w = 800, h = 100 },
    { x = 340, y = 400, w = 120, h = 20 },
    { x = 100, y = 320, w = 120, h = 20 },
    { x = 580, y = 320, w = 120, h = 20 },
}
L[6].flag = { x = 740, y = 460, w = 20, h = 40 }
L[6].boxes = {
    { x = 350, y = 460, w = 40, h = 40 },
    { x = 420, y = 460, w = 40, h = 40 },
}
L[6].turrets = {}

L[7].platforms = {
    { x = 0, y = 500, w = 800, h = 100 },
    { x = 260, y = 380, w = 120, h = 20 },
    { x = 500, y = 300, w = 120, h = 20 },
}
L[7].flag = { x = 550, y = 260, w = 20, h = 40 }
L[7].boxes = {}
L[7].turrets = {
    { x = 300, y = 460, w = 20, h = 20 },
    { x = 400, y = 460, w = 20, h = 20 },
    { x = 620, y = 460, w = 20, h = 20 },
}

L[8].platforms = {
    { x = 0, y = 500, w = 800, h = 100 },
    { x = 120, y = 420, w = 120, h = 20 },
    { x = 320, y = 340, w = 120, h = 20 },
    { x = 520, y = 160, w = 120, h = 20 },
    { x = 250, y = 0, w = 20, h = 500 },
    { x = 400, y = 0, w = 20, h = 500 },
}
L[8].flag = { x = 600, y = 120, w = 20, h = 40 }
L[8].boxes = {}
L[8].turrets = {
    { x = 500, y = 460, w = 20, h = 20 },
}

L[9].platforms = {
    { x = 0, y = 500, w = 300, h = 100 },
    { x = 600, y = 500, w = 200, h = 100 },
    { x = 420, y = 410, w = 140, h = 20 },
    { x = 220, y = 310, w = 140, h = 20 },
    { x = 620, y = 310, w = 140, h = 20 },
}
L[9].flag = { x = 680, y = 270, w = 20, h = 40 }
L[9].boxes = {}
L[9].turrets = {
    { x = 380, y = 460, w = 20, h = 20 },
    { x = 600, y = 460, w = 20, h = 20 },
}

L[10].platforms = {
    { x = 0, y = 500, w = 800, h = 100 },
}
L[10].flag = { x = 720, y = 460, w = 20, h = 40 }
L[10].boxes = {
    { x = 320, y = 460, w = 40, h = 40 },
    { x = 360, y = 460, w = 40, h = 40 },
    { x = 400, y = 460, w = 40, h = 40 },
    { x = 440, y = 460, w = 40, h = 40 },
    { x = 480, y = 460, w = 40, h = 40 },
}
L[10].turrets = {
    { x = 160, y = 460, w = 20, h = 20 },
}

return L
