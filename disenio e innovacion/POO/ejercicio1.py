#------------------------------------------------------------------------------------------
#       Clases
#------------------------------------------------------------------------------------------

class Robot:
    #Inicio los atributos
    def __init__(self, nombre, carga, estado, posY, posX):
        self.nombre = nombre        #name´s robot
        self.carga = carga          #porcentaje de carga
        self.estado = estado        #Encendido / apagado
        self.posY = posY            #posicion actual Y
        self.posX = posX            #posicion actual X

    #Inicio metodos
    def cargar(self):
        self.carga = 100
        print(f"{self.nombre} esta cargado {self.carga}%")

    def avanzar(self, x, y):
        if self.estado == "on":
            self.posX = self.posX + x
            self.posY = self.posY + y
            self.carga = self.carga - 1
            print(f"{self.nombre} se ubica en ( {self.posX} , {self.posY} )")
        else:
            print(f"{self.nombre} apagado, no se puede mover")


    def datos(self):
        print(f"{self.nombre} esta {self.estado} con {self.carga}% ubicado en ( {self.posX} , {self.posY} )")
    #Ej
    #roberto = Robot("robert", 45, "on", 0, 0)
    #roberto.avanzar(-1,3)


class dron(Robot):
    #Atributos
    posZ = 100

    #Polimorfismo, modifique la accion de avanzar que hacia el padre
    def avanzar(self, x, y, z):
        if self.estado == "on":
            self.posX = self.posX + x
            self.posY = self.posY + y
            self.posZ = self.posZ + z
            self.carga = self.carga - 1
            if z != 0:
                self.carga = self.carga - 1
            print(f"{self.nombre} se ubica en ( {self.posX} , {self.posY}, {self.posZ} )")
        else:
            print(f"{self.nombre} apagado, no se puede mover")
    def datos(self):
        print(f"{self.nombre} esta {self.estado} con {self.carga}% ubicado en ( {self.posX} , {self.posY}, {self.posZ} )")
    #ej
    #avion = dron("droncito",55,"on",0,0)
    #avion.avanzar(1,3,0)

class brazo(Robot):
    #Atributos
    rotZ = 0 #en grados/degrees

    #Polimorfismo, modifique la accion de avanzar que hacia el padre
    def avanzar(self, x, y, theta):
        if self.estado == "on":
            self.posX = self.posX + x
            self.posY = self.posY + y
            self.rotZ = self.rotZ + theta
            self.carga = self.carga - 1
            if theta != 0:
                self.carga = self.carga - 1
            print(f"{self.nombre} se ubica en ( {self.posX} , {self.posY}) rotado {self.rotZ} grados ")
        else:
            print(f"{self.nombre} apagado, no se puede mover")
    def datos(self):
        print(f"{self.nombre} esta {self.estado} con {self.carga}% ubicado en ( {self.posX} , {self.posY} ) rotado {self.rotZ} grados ")

    #ej
    #braz = brazo("arm1",55,"on",0,0)
    #braz.avanzar(1,3,0)
        
#------------------------------------------------------------------------------------------
#   Empiezo consola
#------------------------------------------------------------------------------------------
loop = 1
menu = 1

while loop :
    if menu :
        menu = 0
        print(f" ")
        print(f" ")
        print(f" ")
        print(f" ")
        print(f"       RUVG, S.A.        ")
        print(f" ")
        print(f"Seleccione la acción a realizar ")
        print(f" ")
        print(f"1) Editar robot de 1 plano")
        print(f"2) Editar Dron")
        print(f"3) Editar brazo robotico simple")
        print(f"4) Mover el robot")
        print(f"5) Mover el dron")
        print(f"6) Mover el brazo")
        print(f"7) Salir")
        print(f" ")
        print(f" ")

        roberto = Robot("robert", 45, "on", 0, 0)
        avion = dron("droncito",55,"on",0,0)
        braz = brazo("arm1",55,"on",0,0)
        
        opcion = int(input("Escriba solo el número: "))

        if opcion == 1:
            #name = input("Nombre del robot: ")
            #etiqueta = input("Nombre etiqueta: ")
            carga = int(input("Carga inicial del robot en numeros enteros: "))
            estado = input("Estado inicial del robot  on/off: ")
            pX = int(input("Posicion inicia en X: "))
            pY = int(input("Posicion inicia en Y: "))

            print(f"Loading.....")
            print(f" ")
            roberto.carga = carga
            roberto.estado = estado
            roberto.posX = pX
            roberto.posY = pY
            print(f"Done")
            name.datos()
            print(f" ")
            #roberto = Robot("robert", 45, "on", 0, 0)
            menu = 1
            
        elif opcion == 2:
            #name = input("Nombre del Dron: ")
            #etiqueta = input("Nombre etiqueta: ")
            carga = int(input("Carga inicial del Dron en numeros enteros: "))
            estado = input("Estado inicial del Dron  on/off: ")
            pX = int(input("Posicion inicia en X: "))
            pY = int(input("Posicion inicia en Y: "))

            print(f"Loading.....")
            print(f" ")
            #name = dron(etiqueta,carga,estado,pX,pY)
            avion.carga = carga
            avion.estado = estado
            avion.posX = pX
            avion.posY = pY
            print(f"Done")
            name.datos()
            print(f" ")
            #ej
            #avion = dron("droncito",55,"on",0,0)
            #avion.avanzar(1,3,0)
            menu = 1
        elif opcion == 3:
            #name = input("Nombre del brazo: ")
            #etiqueta = input("Nombre etiqueta: ")
            carga = int(input("Carga inicial del brazo en numeros enteros: "))
            estado = input("Estado inicial del Brazo  on/off: ")
            pX = int(input("Posicion inicia en X: "))
            pY = int(input("Posicion inicia en Y: "))

            print(f"Loading.....")
            print(f" ")
            #name = brazo(etiqueta,carga,estado,pX,pY)
            braz.carga = carga
            braz.estado = estado
            braz.posX = pX
            braz.posY = pY
            print(f"Done")
            name.datos()
            print(f" ")

            #ej
            #braz = brazo("arm1",55,"on",0,0)
            #braz.avanzar(1,3,0)
        elif opcion == 4:
            mX= int(input("Desplazamiento en X: "))
            mY= int(input("Desplazamiento en Y: "))
            roberto.avanzar(mX,mY)
            roberto.datos()
            menu = 1
            
        elif opcion == 5:
            #name = input("Nombre del dron a mover: ")
            mX= int(input("Desplazamiento en X: "))
            mY= int(input("Desplazamiento en Y: "))
            mZ= int(input("Desplazamiento en Z: "))
            avion.avanzar(mX,mY,mZ)
            avion.datos()
            menu = 1
            
        elif opcion == 6:
            #name = input("Nombre del brazo a mover: ")
            mX= int(input("Desplazamiento en X: "))
            mY= int(input("Desplazamiento en Y: "))
            mG= int(input("Grados a deplazar: "))
            braz.avanzar(mX,mY,mG)
            braz.datos()
            menu = 1

            
        elif opcion == 7:
            break
        else:
            print(f"Ingresa una opción valida")
            menu = 1

        
























    
