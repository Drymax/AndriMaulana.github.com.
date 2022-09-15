import flash.display.MovieClip;

stop();
var nilai:int = 0;
var nomorSoal:int = 0;
var hasil:hasilMC;
var tempSoal:Array;
var tempJawaban:Array;
var gameAktif:Boolean = true;
var fps:int = 30; //frame per second 
var waktuSoal:int = waktuMaks*fps;
var halamanScore:int = 12;
var pengaturWaktu:MovieClip = timerMC;

 
function acakSoal():void{
	//mengacak soal
	tempSoal = soal.slice(0, soal.length);
	for (var i:int = 0; i < soal.length; i++){
		var acak:int = Math.floor(Math.random()*soal.length);
		var temp:Array = tempSoal[acak];
		tempSoal[acak] = tempSoal[i];
		tempSoal[i] = temp;
	}
}
 
function tampilkanSoal():void{
	//tampilkan soal
	soalTxt.text = tempSoal[nomorSoal][0];
	//acak jawaban
	tempJawaban = tempSoal[nomorSoal].slice(1, 5);
	for (var i:int = 0; i < tempJawaban.length; i++){
		var acak:int = Math.floor(Math.random()*tempJawaban.length);
		var temp:String = tempJawaban[acak];
		tempJawaban[acak] = tempJawaban[i];
		tempJawaban[i] = temp;
	}
	//tampilkan jawaban
	jawab1.jawabanTxt.text = tempJawaban[0];
	jawab2.jawabanTxt.text = tempJawaban[1];
	jawab3.jawabanTxt.text = tempJawaban[2];
	jawab4.jawabanTxt.text = tempJawaban[3];
}
 
function setupKuis():void{
	acakSoal();
	tampilkanSoal();
	//mengatur jawaban
	jawab1.stop();
	jawab2.stop();
	jawab3.stop();
	jawab4.stop();
	jawab1.addEventListener(MouseEvent.CLICK, cekJawaban);
	jawab2.addEventListener(MouseEvent.CLICK, cekJawaban);
	jawab3.addEventListener(MouseEvent.CLICK, cekJawaban);
	jawab4.addEventListener(MouseEvent.CLICK, cekJawaban);
	//listener untuk efek tombol
	jawab1.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
	jawab2.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
	jawab3.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
	jawab4.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
	//mouse out
	jawab1.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
	jawab2.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
	jawab3.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
	jawab4.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
	//timer
	pengaturWaktu.addEventListener(Event.ENTER_FRAME, aturWaktu);
}
function mouseOver(e:MouseEvent):void{
	e.currentTarget.gotoAndStop(2);
}
 
function mouseOut(e:MouseEvent):void{
	e.currentTarget.gotoAndStop(1);
}
 
function cekJawaban(e:MouseEvent):void{
	if (gameAktif){
		var nomorJawaban:int = int(e.currentTarget.name.substr(5))-1;
		if (tempJawaban[nomorJawaban] == tempSoal[nomorSoal][1]){
			//jawaban benar
			tampilkanHasil(1);
			nilai+=10;
		}else{
			//jawaban salah
			tampilkanHasil(2);
		}
	}
}
 
function tampilkanHasil(tp:int):void{
	hasil = new hasilMC;
	hasil.x = 400;
	hasil.y = 240;
	hasil.gotoAndStop(tp);
	hasil.scaleX = 0.2;
	hasil.scaleY = 0.2;
	hasil.waktu = 0;
	hasil.tp = tp;
	hasil.addEventListener(Event.ENTER_FRAME, efekPopup);
	addChild(hasil);
	//reset timer
	gameAktif = false;
	waktuSoal = waktuMaks*fps;
}
 
function efekPopup(e:Event):void{
	var ob:Object = e.currentTarget;
	if (ob.scaleX < 1){
		ob.scaleX+=0.1;
		ob.scaleY+=0.1;
	}
	if (ob.waktu > -1){
		ob.waktu++;
		if (ob.waktu > 60){		
			ob.waktu = -1;
			//tambah no soal
			nomorSoal++;
			ob.removeEventListener(Event.ENTER_FRAME, efekPopup);
			removeChild(DisplayObject(ob));
			if (ob.tp < 4){
				if (nomorSoal < soalMaks){	
					gameAktif = true;
					tampilkanSoal();
				}else{
					//soal habis
					gameAktif = false;
					tampilkanHasil(4);
				}
			}else{
				//pindah ke halaman score setelah soal habis
				pengaturWaktu.removeEventListener(Event.ENTER_FRAME, aturWaktu);
				gotoAndStop(halamanScore);
			}			
		}		
	}
}

function aturWaktu(e:Event):void{
	if (gameAktif){
		waktuSoal--;
		if (waktuSoal < 0){
			waktuSoal = waktuMaks*fps;
			gameAktif = false;
			tampilkanHasil(3);
		}
	}
	//tampilkan dalam movieclip pengaturWaktu
	pengaturWaktu.barMC.scaleX = waktuSoal/(waktuMaks*fps);
}
