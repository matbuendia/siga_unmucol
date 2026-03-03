import 'package:flutter/material.dart';

class PantallaCurso extends StatelessWidget{
  const PantallaCurso({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold( 
      appBar: AppBar(
        title: const Text(
          'Mis Cursos',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        backgroundColor: Colors.white38,
      ),
      
      body: 
      Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/736x/00/77/80/00778091f156323e85e4506bcc6b2cf2.jpg'),
            fit: BoxFit.cover,
          ),
        ),

      child: Column(
        children: [
          const Padding(  
            padding: EdgeInsets.all(16.0),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(20),
            width: double.infinity, //ocupa todo el ancho
            height: 140,
            decoration: BoxDecoration(  
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(15), //redondear esquinas
              image: DecorationImage( 
                image: const NetworkImage('https://i.pinimg.com/736x/0b/6e/88/0b6e881b001b3427d07d21c249937dbe.jpg'),
                fit: BoxFit.cover,
                
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                  ),
              ),
            ),
            
            child: const Column(  
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text( 
                  'Matemáticas',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                ),
                Text(
                  'Prof. Orlando Martinez',
                  style: TextStyle(color: Colors.white70),
                ),
                Spacer(),  //NOs envia al fondo del container
                Text(
                  'Sección: A1',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(20),
            width: double.infinity, //ocupa todo el ancho
            height: 140,
            decoration: BoxDecoration(  
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(15), //redondear esquinas

              image: DecorationImage(
                image: const NetworkImage('https://i.pinimg.com/736x/81/d0/44/81d044473d7ab0a3cac50fa58dc12a90.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), 
                  BlendMode.darken),
              ),
        
            ),
            
            child: const Column(  
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text( 
                  'Lenguaje',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                ),
                Text(
                  'Prof. Stefanny Pinzón',
                  style: TextStyle(color: Colors.white70),
                ),
                Spacer(),  //NOs envia al fondo del container
                Text(
                  'Sección: C1',
                  style: TextStyle(color: Colors.white),
                ),
              ]
            )
          
          )
        ]
      )

      )
    );
  }
}