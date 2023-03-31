# exctrl.py
# ==============================================================================
# Este es un programa que se presenta como ejemplo para manejar al robot MyCobot 
# 280 desde su API de Python.
# ==============================================================================
from pymycobot.mycobot import MyCobot
import time

# Se inicializa el objeto MyCobot en el puerto serial adecuado y con el baudaje
# por defecto
mc = MyCobot("COM21", 115200)
wait_time = 3 # tiempo de espera entre movimientos

# Las siguientes secuencias de comandos ejemplifican cómo hacer ciertas tareas
# y obtener información del robot, comente y descomente a conveniencia. La idea
# de este primer acercamiento con el robot es validar experimentalmente las 
# rutinas numéricas de cinemática que desarrolló para el robot en los 
# laboratorios 6 y 7. 
# PUEDE REVISARSE LA ESPECIFICACIÓN COMPLETA DE LA API EN:
# https://docs.elephantrobotics.com/docs/gitbook-en/7-ApplicationBasePython/7.2_API.html

# ==============================================================================
# Se imprime la configuración (q) actual del robot en grados.
# ==============================================================================
print('configuración: ', mc.get_angles())
# ------------------------------------------------------------------------------

# ==============================================================================
# Se imprime la pose de efector final (BT_E) actual del robot. El formato en que
# imprime es: [x, y, z, rx, ry, rz]
# ==============================================================================
print('pose de efector final: ', mc.get_coords())
# ------------------------------------------------------------------------------

# ==============================================================================
# Se envía una configuración establecida (en grados) al robot para que la 
# ejecute. Dicho de otra forma, se envían las referencias a los servos de cada 
# una de las juntas. El segundo parámetro que se envía, luego de la 
# configuración, es la velocidad de los motores que va de 0 a 100.
# ==============================================================================
mc.send_angles([0, 0, 0, 0, 0, 0], 50) # configuración 1 (HOME)
time.sleep(wait_time)
mc.send_angles([0, 45, -90, 45, 0, -45], 50) # configuración 2
time.sleep(wait_time)
# ------------------------------------------------------------------------------

# ==============================================================================
# Se abre y cierra el gripper. El segundo parámetro es la velocidad del motor.
# ==============================================================================
mc.set_gripper_state(0, 70) # se abre el gripper
time.sleep(wait_time)
mc.set_gripper_state(1, 70) # se cierra el gripper
time.sleep(wait_time)
# ------------------------------------------------------------------------------

# ==============================================================================
# Se regresa el robot a la configuración HOME y se imprimen de nuevo la 
# configuración y la pose de efector final actuales. La idea con esto es tener
# cierta medida o noción de la repetibilidad en los movimientos del robot.
# ==============================================================================
mc.send_angles([0, 0, 0, 0, 0, 0], 50)
time.sleep(wait_time)
print('configuración: ', mc.get_angles())
print('pose de efector final: ', mc.get_coords())
# ------------------------------------------------------------------------------


