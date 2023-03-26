class Person:
    #Funcion para inicializar atributos
    def __init__ (self, name, age): #en C esto seria un construcctor
        self.name = name            #atributo.x = variable
        self.age = age

    def talk(self):
        print(f"{self.name} waves and says hi!")

#Acciones con la clase Person

#Instanciar un objeto

#acceder a tributos
p1 = Person("John", 36)

print(p1.name)
print(p1.age)
p1.talk()


#Child class sin nada diferente
class Student(Person):
    pass    #basicamente q no haga nada

#-------------------------------------------------------------------------
#Child class con atributos adicionales
class Teacher(Person):
    #Atributos
    title = "ENG"

    #Puedo re.definir __init__, pero si quiero mantener la funcionalidad
    #del padre debo re-escribir la funcion del padre
    #def __init__(self, title):
    #Person.__init__(self, name, age)
    #self.title = title
    
    def greet(self):
        print(f"{self.title}{self.name} greets all the student!")

    #Polimorfismo, modifique la accion que hacia el padre
    def talk(self, listener):
        print(f"{self.title} {self.name} greet {listener}")
#-------------------------------------------------------------------------

prof1 =Teacher("paquillo", 35)
print(prof1.name)
p1.talk()           #aqui se muestra el original
prof1.talk("pelu")  #aqui se muestra el modificado para el hijo


#Para ver POO en C++ ver el siguiente link:
# https://wokwi.com/projects/355703634162296833
