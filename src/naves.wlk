class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible=0
	method esTranquila()= combustible>=4000 && velocidad<=12000
	method cargarCombustible(cant){combustible+=cant}
	method descargarCombustible(cant){(combustible-=cant).max(0)}
	method prepararViaje(){self.cargarCombustible(30000) self.acelerar(5000)}
	method acelerar(cuanto) {
		velocidad = ((velocidad + cuanto).min(100000)).max(0)
	}
	method desacelerar(cuanto) {(velocidad-=cuanto).max(0) }
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method acercarseUnPocoAlSol(){(direccion+=1).min(10)}
	method alejarseUnPocoDelSol(){(direccion-=1).max(10)}
	method recibirAmenaza(){self.escapar() self.avisar()}
	method escapar(){}
	method avisar(){}
	method estaDeRelajo()=self.esTranquila()&& self.tienePocaActividad()
	method tienePocaActividad()
	
}

class NavesBalizas inherits NaveEspacial{
	var property colorDeBaliza="azul"
	var colorCambiado=0
	override method tienePocaActividad()=colorCambiado==0
	override method escapar(){self.irHaciaElSol()} 
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	method cambiarColorDeBaliza(colorNuevo){colorDeBaliza=colorNuevo colorCambiado+=1}
	override method prepararViaje(){super()
		self.cambiarColorDeBaliza("verde") self.ponerseParaleloAlSol()
	}
	override method esTranquila()=super()&& not colorDeBaliza=="rojo"
//rever el video de super
}

class NavesDePasajeros inherits NaveEspacial{
	var property cantidadDePasajeros
	var property racionesDeComida=0
	var property racionesDeBebida=0
	var racionesDeComidaServidas=0
	override method tienePocaActividad()=racionesDeComidaServidas<50
	override method escapar(){velocidad=velocidad*2 }
	override method avisar(){
		self.servirComida() 	
		self.servirBebida()
	}
	method servirComida(){
		(racionesDeComida-=cantidadDePasajeros).max(0)
		racionesDeComidaServidas=cantidadDePasajeros
	}
	method servirBebida(){(racionesDeBebida-=(cantidadDePasajeros*2)).max(0)}	
	
	override method prepararViaje(){super()
		self.cargarComida(4) self.cargarBebidas(6) self.acercarseUnPocoAlSol()
	}
	method cargarComida(cantidad){ racionesDeComida+=cantidad}
	method cargarBebidas(cantidad){ racionesDeBebida+=cantidad}
	method cargarPasajeros(cantidad){cantidadDePasajeros+=cantidad}

}


class NavesDeCombate inherits NaveEspacial{
	var invisibilidad=false
	var misilesDesplegados=0
	const mensajes=[]
	override method tienePocaActividad()=self.esEscueta()
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method esTranquila()=super() && misilesDesplegados==0
	
	override method prepararViaje(){super()
		self.ponerseInvisible() self.replegarMisiles() 
		self.acelerar(15000) self.emitirMensaje("Saliendo en mision")
		
	}
	method ponerseVisible(){
		invisibilidad=true
	}
	
	method ponerseInvisible(){
		invisibilidad=false
	}
	
	method estaInvisible()=invisibilidad
	
	method desplegarMisiles(){
		misilesDesplegados+=1
	}
	
	method replegarMisiles(){
		(misilesDesplegados-=1).max(0)
	}
	method misilesDesplegados()=misilesDesplegados
	
	method emitirMensaje(mensaje){mensajes.add(mensaje)}
	
	method mensajesEmitidos()=mensajes
	
	method primerMensajeEmitido()=mensajes.first()
	
	method ultimoMensajeEmitido()=mensajes.last()
	
	method esEscueta()=not mensajes.contains({msj=>msj.lenght()>=30})
	
	method emitioMensaje(mensaje)=mensajes.lenght()>=1
	
}


class NaveHospital inherits NavesDePasajeros{
	
	var property tieneQuirofanosPreparados
	override method recibirAmenaza(){super() self.prepararQuirofanos()}
	override method esTranquila()=super()&& tieneQuirofanosPreparados
	method prepararQuirofanos(){
		if(cantidadDePasajeros<1) tieneQuirofanosPreparados=false 
		else tieneQuirofanosPreparados=true
	}
}

class NaveDeCombateSigilosa inherits NavesDeCombate{
 
 	override method escapar(){super() self.desplegarMisiles() self.ponerseInvisible()} 
	override method esTranquila()=super()&& self.estaInvisible()
}