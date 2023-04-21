#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_ints.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "driverlib/adc.h"
#include "driverlib/debug.h"
#include "driverlib/fpu.h"
#include "driverlib/gpio.h"
#include "driverlib/interrupt.h"
#include "driverlib/pin_map.h"
#include "driverlib/rom.h"
#include "driverlib/sysctl.h"
#include "driverlib/timer.h"
#include "driverlib/uart.h"
#include "utils/uartstdio.h"
#include "driverlib/ssi.h"

/*
 * Declaracion de Variables Temporales
 */
float v0, v1,v2,v3,v4; // para ilustrar el uso devariables tipo float
#define NUM_SPI_DATA 1 // N�mero de palabras que se env�an cadavez
#define SPI_FREC 4000000 // Frecuencia para el reloj del SPI
#define SPI_ANCHO 16 // N�mero de bits que se env�an cada vez,entre 4 y 16


uint16_t dato = 0b0111000000000000; // Para lo que se env�a por SPI.
uint16_t contador = 2048; // Para lo que se env�a por SPI.

// Declaracion de Variables para PID
float uk_float=0;
float uk2=0;
float ek=0;
float ed=0;
float Ek=0;
float ek_1 = 0;
float Ek_1 = 0;
float Kp = 10;
float Ki = 0.0001;
float Kd = 0;
float delta = 0.001;
uint16_t uk_int = 0;
float k1= 0;
float k2= 0;
float k3= 0;
float Nbar =0;
float ref_n = 0;
float vc1_n = 0;
float vc2_n = 0;
float vc3_n = 0;
float ref = 0; // PE3
float vc1 = 0; // PE2
float vc2 = 0;
float vc3 = 0;
int Seleccion = 2; // Selecciona el controlador a aplicar
uint16_t freq_muestreo = 10000; // En Hz

// Definiciones para calculos de estados de las variables de estado
float alc00 = -1100;
float alc01 = 92.6;
float alc02 = -100;
float alc10 = 0.0;
float alc11 = -81.4;
float alc12 = -1000.0;
float alc20 = -10.0;
float alc21 = 12.8;
float alc22 = -20.0;
float b0 = 1000;
float b1 = 0;
float b2 = 0;
float L0 = 7.3559;
float L1 = 81.4361;
float L2 = -2.8159;
float Out = 0;

void Timer0IntHandler(void){
    uint32_t pui32DataTx[NUM_SPI_DATA];
    uint8_t ui32Index;
    uint32_t pui32ADC0Value[5];
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    ADCProcessorTrigger(ADC0_BASE, 0);
    while(!ADCIntStatus(ADC0_BASE, 0, false))
    {

    }
    ADCIntClear(ADC0_BASE, 0); // Limpiamos lainterrupci�n del ADC0
    ADCSequenceDataGet(ADC0_BASE, 0, pui32ADC0Value);
    if (Seleccion <= 1){
        v0 = pui32ADC0Value[0]*3.3/4095.0; // Convertir a voltios
        v1 = pui32ADC0Value[1]*3.3/4095.0; // Convertir a voltios
        v2 = pui32ADC0Value[2]*3.3/4095.0; // Convertir a voltios
        v3 = pui32ADC0Value[3]*3.3/4095.0; // Convertir a voltios
        v4 = pui32ADC0Value[4]*3.3/4095.0; // Convertir a voltios
    }
    if (Seleccion == 2){
        v0 = pui32ADC0Value[0]*3.3/4095.0; // Convertir a voltios
        v1 = pui32ADC0Value[1]*3.3/4095.0; // Convertir a voltios
    }
    pui32DataTx[0] = (uint32_t)(dato);
    for(ui32Index = 0; ui32Index < NUM_SPI_DATA ; ui32Index++)
    {
        SSIDataPut(SSI0_BASE, pui32DataTx[ui32Index]);
 }
    while(SSIBusy(SSI0_BASE))
    {

    }
 /*
 * LABORATORIO 6
 */
 /*
 * Variables Controlador
 */
    if (Seleccion <= 1){
        ref = v0; // PE3
        vc1 = v1; // PE2
        vc2 = v2; // PE1
        vc3 = v3 /*PE0*/ -v4 /*PD3*/;
    }
    if (Seleccion == 2){
        ref = v0; // PE3
        Out = v1; // PE2
    }
 /*
  * Definicion de K Nbar
  */
    if (Seleccion == 0){
        Nbar = 3.575;
        k1= 0.18;
        k2= 2.395;
        k3= -21.79;
    }
    if (Seleccion == 1){
        Nbar = 7.7;
        k1= 0.53;
        k2= 6.17;
        k3= -63.34;
    }
    if (Seleccion == 2){
        Nbar = 10.0995;
        k1= 0.7122;
        k2= 8.3873;
        k3= -53.7034;   // K y Nbar de laboratorio 7 Primera parte
    }
 /*
 * Definicion de Controlador
 */
    if (Seleccion <= 1){
        ref_n = ref*Nbar;
        vc1_n = k1*vc1;
        vc2_n = k2*vc2;
        vc3_n = k3*vc3;
        uk_float = ref_n -(vc1_n + vc2_n + vc3_n);
    }
    if (Seleccion == 2){
        ref_n = ref*Nbar;
        vc1_n = k1*vc1;
        vc2_n = k2*vc2;
        vc3_n = k3*vc3;
        uk_float = ref_n -(vc1_n + vc2_n + vc3_n);

        // Calculo de estimados de las variables de Estado
        vc1 = vc1 + (1.0/freq_muestreo)*(alc00*vc1 + alc01*vc2 + alc02*vc3 + b0*uk_float + L0*Out);
        vc2 = vc2 + (1.0/freq_muestreo)*(alc10*vc1 + alc11*vc2 + alc12*vc3 + b1*uk_float + L1*Out);
        vc3 = vc3 + (1.0/freq_muestreo)*(alc20*vc1 + alc21*vc2 + alc22*vc3 + b2*uk_float + L2*Out);

    }

 // Limites de Uk para que salida este entre el rango
    uk_float=uk_float*4095.0/3.3;
    if(uk_float>4095.0){
        uk_float = 4095.0;
    }
    if(uk_float<0){
 uk_float = 0;
 }
 uk_int = (int)(uk_float);
// Mapeo para salida por SPI para el DAC
 dato = 0b0111000000000000;
 dato = dato + uk_int;
}
int
main(void)
{
 uint32_t pui32residual[NUM_SPI_DATA];
 SysCtlClockSet(SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN |SYSCTL_XTAL_16MHZ); // 80 MHz
 // Configuraci�n de SPI
 SysCtlPeripheralEnable(SYSCTL_PERIPH_SSI0);
 SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);
 GPIOPinConfigure(GPIO_PA2_SSI0CLK);
 GPIOPinConfigure(GPIO_PA3_SSI0FSS);
 GPIOPinConfigure(GPIO_PA4_SSI0RX);
 GPIOPinConfigure(GPIO_PA5_SSI0TX);
 GPIOPinTypeSSI(GPIO_PORTA_BASE, GPIO_PIN_5 | GPIO_PIN_4 | GPIO_PIN_3 |GPIO_PIN_2);
 SSIConfigSetExpClk(SSI0_BASE, SysCtlClockGet(), SSI_FRF_MOTO_MODE_0,SSI_MODE_MASTER, SPI_FREC, SPI_ANCHO);
 SSIEnable(SSI0_BASE);




 // Configuraci�n del ADC IMPORTANTE
 SysCtlPeripheralEnable(SYSCTL_PERIPH_ADC0);
 SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE); //Activandopuerto de los AIN0 y ANI1
 SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD); //Activandopuerto de los AIN0 y ANI1
 GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_0); //Configura el pin PE0 como AN-Input
 GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_1); //Configura el pin PE1 como AN-Input
 GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_2); // Configura el pin PE2 como AN-Input
 GPIOPinTypeADC(GPIO_PORTE_BASE, GPIO_PIN_3); //Configura el pin PE3 como AN-Input
 GPIOPinTypeADC(GPIO_PORTD_BASE, GPIO_PIN_3); //Configura el pin PD3 como AN-Input
 ADCSequenceConfigure(ADC0_BASE, 0, ADC_TRIGGER_PROCESSOR, 0); // Se configura la secuencia 2 para tomar 2 de 4 posibles muestras.
 ADCSequenceStepConfigure(ADC0_BASE, 0, 0, ADC_CTL_CH0); // Step 0 en la secuencia 2: PE3 Canal 0 (ADC_CTL_CH0) en modo single-ended (por defecto).
 ADCSequenceStepConfigure(ADC0_BASE, 0, 1, ADC_CTL_CH1); // Step 1 en la secuencia 2: PE2 Canal 0 (ADC_CTL_CH0) en modo single-ended (por defecto).
 ADCSequenceStepConfigure(ADC0_BASE, 0, 2, ADC_CTL_CH2); // Step 2 en la secuencia 2: PE1 Canal 0 (ADC_CTL_CH0) en modo single-ended (por defecto).
 ADCSequenceStepConfigure(ADC0_BASE, 0, 3, ADC_CTL_CH3); // Step 3 en la secuencia 2: PE0 Canal 0 (ADC_CTL_CH0) en modo single-ended (por defecto).
 ADCSequenceStepConfigure(ADC0_BASE, 0, 4, ADC_CTL_CH4 | ADC_CTL_IE | ADC_CTL_END); // Step 4 en la secuencia 2: PD3 Canal 1 (ADC_CTL_CH1) en modo single-ended (por defecto),
 ADCSequenceEnable(ADC0_BASE, 0); //Activando secuencia 2 de ADC0
 ADCIntClear(ADC0_BASE, 0); //Limpiamos la bandera de interrupci�n del ADC0.



 //Configurando Timer 0
 SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
 IntMasterEnable();
 TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
 TimerLoadSet(TIMER0_BASE, TIMER_A, (uint32_t)(SysCtlClockGet()/freq_muestreo));
 IntEnable(INT_TIMER0A);
 TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
 TimerEnable(TIMER0_BASE, TIMER_A);
 while(1)
 {
 }
}
