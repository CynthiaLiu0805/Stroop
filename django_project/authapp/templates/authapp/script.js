var TEXT =[
    "RED",
    "BLUE",
    "GREEN",
    "PINK",
    "BLACK",
    "ORANGE",
    "GRAY",
    "YELLOW",
];

var COLORS = [
    "red",
    "blue",
    "green",
    "pink",
    "black",
    "orange",
    "gray",
    "#ffee00",
];

var BUTTONS = [{
    'name':'red',
    'text':'RED',
},{
    'name':'blue',
    'text':'BLUE',
},{
    'name':'green',
    'text':'GREEN',
},{
    'name':'pink',
    'text':'PINK',
},{
    'name':'black',
    'text':'BLACK',
},{
    'name':'orange',
    'text':'ORANGE',
},{
    'name':'gray',
    'text':'GRAY',
},{
    'name':'#ffee00',
    'text':'YELLOW',
},]

///////buttons/////
var multiChoices= BUTTONS.sort();

var choice = document.getElementById('buttons');
var grid = document.createElement('section');
grid.setAttribute('class', 'grid');
choice.appendChild(grid);

multiChoices.forEach(function (item) {
  var buttons = document.createElement('div');
  buttons.classList.add('buttons');
  buttons.dataset.name = item.name;
  buttons.textContent = item.text;
  grid.appendChild(buttons);
});



var colorIndex
var textIndex

////next random text with random color////
function next(){

    colorIndex=Math.floor(COLORS.length * Math.random())
    textIndex=Math.floor(TEXT.length * Math.random())

    document.getElementById("Text").style.color=COLORS[colorIndex];

    document.getElementById('Text').innerHTML=TEXT[textIndex];

}

//////////////////About score//////////
var score = document.getElementById('score')
var scoresofar = 0
////////check if button match the color on text///
/////if so add score////
grid.addEventListener('click', match); 
function match(){
    var iclick = event.target

    if (iclick.dataset.name === COLORS[colorIndex]){

        scoresofar+=sec
        score.innerHTML = "Score : " + scoresofar
        resettime()
        next()
        

    }else{
        grid.removeEventListener('click',match)
        alert("game over")
        stop()


    }
    
    

}


////////////////////////////About timer//////////////////////////////
var timer
var sec = 11

var time = document.getElementById('timer')
function timer() {
    sec--;
    while (sec===0){
        alert("You are running out of time")//////some animation
        sec=11
        
    }
    showtime()
}

function showtime(){
    time.innerHTML = "Timer : " + sec
}

function resettime(){
    sec=11
    next()
    timer()
    
}



//////maybe could delete???
var start = document.getElementById("start")
start.addEventListener('click', function(){
    next()
    timer = setInterval(timer,1000);
      
})

var stop
function stop(){
    timer=clearInterval(timer)
}

var reset = document.getElementById("reset")
reset.addEventListener('click', function(){
    location.reload()
    timer = clearInterval(timer);
    sec=10;
    time.innerHTML="Timer : 10"
})
//////until here///