import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
void main() {
  runApp(Snake());
}
class Snake extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView>{
  static List<int> snakePosition = [45, 65, 85, 105, 125];
int numberOfSquares = 760;

static var randomNumber = Random();
int food = randomNumber.nextInt(760);
void generateNewFood(){
  food = randomNumber.nextInt(740);
}
void startGame(){
  snakePosition = [45, 65, 85, 105, 125];
  const duration = Duration(milliseconds: 400);
  Timer.periodic(duration, (Timer timer){
    updateSnake();
    if (gameOver()){
      timer.cancel();
      _showGameOverScreen();
    }
  });
}
var direction = 'down';
void updateSnake(){
  setState(() {
    switch (direction) {
      case 'down':
        if (snakePosition.last > 760){ //ye ager end pr aa gya hai to loop krne ke liye walls ke through
          snakePosition.add(snakePosition.last + 20 - 760);
        }
        else
          {
            snakePosition.add(snakePosition.last + 20);
          }
        break;
      case 'up' :
        if(snakePosition.last < 20){ //loop krne ke liye
          snakePosition.add(snakePosition.last - 20 + 760);
        }
        else
          {
            snakePosition.add(snakePosition.last - 20);
          }
        break;
      case 'left' :
        if (snakePosition.last % 20 == 0){ //loop krne ke liye
          snakePosition.add(snakePosition.last - 1 + 20);
        }
        else
          {
            snakePosition.add(snakePosition.last - 1);
          }
        break;
      case 'right' :
        if ((snakePosition.last + 1 ) % 20 == 0 ){ //loop krne ke liye
          snakePosition.add(snakePosition.last + 1 - 20);
        }
        else
          {
            snakePosition.add(snakePosition.last + 1);
          }
        break;
        default:
    }

    if (snakePosition.last == food){
      generateNewFood();
    }
    else {
      snakePosition.removeAt(0);
    }
  });
}
bool gameOver(){
  for(int i = 0; i < snakePosition.length; i++){
    int count = 0;
    for(int j = 0; j < snakePosition.length; j++){
      if(snakePosition[i] == snakePosition[j]){
        count++;
      }
      if(count == 2){
        return true;
      }
    }
  }
  return false;
}
void _showGameOverScreen(){
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      backgroundColor: Colors.black,
      title:const Text('GAME OVER ☠',
        style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,
        ),
      ),
      content: Text (' Score : ' + (snakePosition.length-5).toString(),
      style:const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,
      ),),
      actions: <Widget> [
        FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Text('Again',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
            onPressed: (){
          startGame();
          Navigator.of(context).pop();
        },
        ),
      ],
    );
  });
}

@override
  Widget build (BuildContext context){
  return Scaffold(
    backgroundColor: Colors.black,
    body: Column(
         children: <Widget> [
           Expanded(
               child: GestureDetector(
                 onVerticalDragUpdate: (details){
                 if (direction != 'up' && details.delta.dy > 0){
                    direction = 'down';
                 }
                 else if(direction != 'down' && details.delta.dy < 0){
                    direction = 'up';
                 }
                 },
                 onHorizontalDragUpdate: (details){
                 if (direction != 'left' && details.delta.dx > 0){
                   direction = 'right';
                    }
                     else if (direction != 'right' && details.delta.dx < 0){
                     direction = 'left';
                     }
                     },
                child: Container(
                 child: GridView.builder(
                   physics: NeverScrollableScrollPhysics(),
                     itemCount: numberOfSquares,
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount (crossAxisCount: 20),
                      itemBuilder: (BuildContext context, int index) {
                       if(snakePosition.contains(index)){
                          return Center (
                           child: Container(
                             padding:const EdgeInsets.all(1),
                            child: ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                             child: Icon(Icons.circle,
                             color: Colors.white,
                             size: 20,)
                        //      Container(
                        //      color: Colors.black,
                        // ),
                      ),
                    ),
                  );
                }
                  if (index == food) {
                     return Container(
                         padding:const EdgeInsets.all(1),
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(20),
                           child: Icon(Icons.bug_report,
                           color: Colors.red,
                           size: 18,),
                           // Container(
                           //   color: Colors.red,
                           // ),
                         )
                     );
                   }
                  else {
                    return Container(
                      child: Container(
                        color: Colors.lightGreen,
                      ),
                      // padding:const EdgeInsets.all(2),
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(10),
                      //   child: Container(
                      //     color: Colors.grey[400],
                      //   ),
                      // ),
                    );
                  }
                },
              ),
            ) ,
           ),
           ),
           Padding(
             padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
               Container(
             width: 80.0,
                 height: 30.0,
                 child:  RawMaterialButton(
                   shape: CircleBorder(),
                   elevation: 10,
                   child:const Text('START',
                     style: TextStyle(color: Colors.white, fontSize: 20),
                   ),
                   onPressed: startGame,
                 ),
              ),
                 // FloatingActionButton(onPressed: startGame,
                 // hoverElevation: 10,
                 // child: Text('START'),
                 //   backgroundColor: Colors.green,
                 //   shape:  CircleBorder(),
                 // ),
                 // GestureDetector(
                 //   onTap: startGame,
                 //   child: const Text ('S T A R T ',
                 //   style: TextStyle(
                 //     color: Colors.white,
                 //     fontSize: 25,
                 //   ),
                 //   ),
                 // ),
                 TextButton(onPressed: (){},
                     child: Text('Score : ' + (snakePosition.length - 5).toString(),
                       style: TextStyle(
                         color: Colors.white, fontSize: 20,
                       ),
                     )
                 ),
                 Column(
                   children: [
                     const Text('made by',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 12,
                     ),
                     ),
                     const Text('@sidvjsingh',
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 12,
                       ),
                     ),
                   ],
                 )
               ],
             ),
           ),
         ],
    ),
  );

}

}

