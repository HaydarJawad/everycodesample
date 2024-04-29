screenres 800, 600, 32
Randomize Timer  ' Seed the random number generator to ensure different outcomes each game

' Initialize ball positions and velocities
Dim shared as integer ball_x = 400, ball_y = 300
Dim shared as integer ball2_x = 200, ball2_y = 150
Dim as integer ball_dx = IIf(Rnd > 0.5, 1, -1), ball_dy = 1
Dim as integer ball2_dx = IIf(Rnd > 0.5, 1, -1), ball2_dy = 2

Dim shared as integer paddle_x = 350, paddle_y = 550
Dim shared as integer score_yellow = 0  ' Score for the yellow ball
Dim shared as integer score_green = 0   ' Score for the green ball
Dim shared as integer ai_offset = 40
Dim As String key
Dim As Long fps
Declare Sub delay(ByVal amt As Single, ByVal thr As Ulong = 2)

Sub delay(ByVal amt As Single, ByVal thr As Ulong)
    Dim As Double t1 = Timer
    Dim As Double t2 = t1 + amt / 1000
    If amt > thr + 0.5 Then Sleep amt - thr, 1
    Do
    Loop Until Timer >= t2
End Sub

Sub PlayBounceSound()
    Shell "aplay /home/infra/Downloads/yell.wav &"
End Sub

Sub PlayCollisionSound()
    Shell "aplay /home/infra/Downloads/gre.wav &"
End Sub

Do
   key = Inkey()
   ' Update AI paddle position dynamically based on the position of both balls
   ' This approach provides more challenge and fairness
    If ball_x > paddle_x + ai_offset + 10 Or ball2_x > paddle_x + ai_offset + 10 Then
        paddle_x += 3
    ElseIf ball_x < paddle_x + ai_offset - 10 Or ball2_x < paddle_x + ai_offset - 10 Then
        paddle_x -= 3
    End If

    ' Update ball positions
    ball_x += ball_dx
    ball_y += ball_dy
    ball2_x += ball2_dx
    ball2_y += ball2_dy

    ' Check collision with paddle for both balls and update scores
    If ball_y >= paddle_y And (ball_x >= paddle_x And ball_x <= (paddle_x + 100)) Then
        ball_dy = -ball_dy ' Bounce the first ball
        score_yellow += 1
        PlayBounceSound() ' Play bounce sound
    ElseIf ball_y >= paddle_y Then
        ball_y = 300 ' Reset first ball position
        ball_dy = -ball_dy
        PlayCollisionSound() ' Play collision sound
    End If

    If ball2_y >= paddle_y And (ball2_x >= paddle_x And ball2_x <= (paddle_x + 100)) Then
        ball2_dy = -ball2_dy ' Bounce the second ball
        score_green += 1
        PlayBounceSound() ' Play bounce sound
    ElseIf ball2_y >= paddle_y Then
        ball2_y = 150 ' Reset second ball position
        ball2_dy = -ball2_dy
        PlayCollisionSound() ' Play collision sound
    End If

    ' Check collision with walls for both balls
    If ball_x < 0 Or ball_x > 800 Then
        ball_dx = -ball_dx
        PlayCollisionSound() ' Play collision sound
    End If
    If ball_y < 0 Or ball_y > 590 Then
        ball_dy = -ball_dy
        PlayCollisionSound() ' Play collision sound
    End If

    If ball2_x < 0 Or ball2_x > 800 Then
        ball2_dx = -ball2_dx
        PlayCollisionSound() ' Play collision sound
    End If
    If ball2_y < 0 Or ball2_y > 590 Then
        ball2_dy = -ball2_dy
        PlayCollisionSound() ' Play collision sound
    End If

    ' Render game elements
    Screenlock
    cls

    ' Draw static and dynamic elements
    line(0, 590)-(800, 590), rgb(255, 255, 255), bf
    circle(ball_x + 5, ball_y + 5), 5, rgb(255, 255, 0)
    paint (ball_x + 5, ball_y + 5), rgb(255, 255, 0)
    circle(ball2_x + 5, ball2_y + 5), 5, rgb(0, 255, 0)
    paint (ball2_x + 5, ball2_y + 5), rgb(0, 255, 0)
    line(paddle_x, paddle_y)-(paddle_x + 100, paddle_y + 10), rgb(255, 0, 0), bf

    ' Display scores with matching colors
    Locate 1, 1
    Color rgb(255, 255, 0)  ' Yellow text for the yellow ball's score
    Print "Yellow Score: "; score_yellow
    Locate 3, 1
    Color rgb(0, 255, 0)    ' Green text for the green ball's score
    Print "Green Score: "; score_green
    Locate 5, 1
    Color rgb(255, 255, 255)  ' Default text color for the greeting
    Print "Have fun - Haydar Jawad"

    Screenunlock

    delay 1.6

Loop Until key = Chr(27) Or key = Chr(255) & "k"
