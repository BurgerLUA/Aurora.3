/obj/item/device/calculator
	name = "calculator"
	desc = "A very basic calculator for performing very basic calculations."
	w_class = 2
	origin_tech = list(TECH_MATERIAL = 1)
	icon_state = "calculator"
	force = 0
	var/calculator_data = "<html>\
	<script>\
		var button_keys 	= 	\['CL','/','x','-','7','8','9','+','4','5','6','nil','1','2','3','enter','0','nil','.'\]\
		var button_flags 	= 	\[0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0\]\
		function onKeyPress(event) {\
			var key = event.keyCode\
			var translator = {99:'0',47:'1',120:'2',42:'2',45:'3',55:'4',56:'5',57:'6',43:'7',52:'8',53:'9',54:'10',49:'12',50:'13',51:'14',13:'15',48:'16',46:'18'}\
			if(key in translator) {inputbutton(translator\[key\])}\
		}\
		document.write('<textarea class='small' id='symbol_area' readonly></textarea>')\
		document.write('<textarea id='display_area' readonly>0</textarea><br>')\
		for(var key in button_keys) {\
			var value = button_keys\[key\]\
			var flag = button_flags\[key\]\
			if(value != 'nil') {document.write('<button class='button_type_' + flag + '' type='button' onclick='inputbutton(' + key + ')'>' + value +  '</button>')}\
			if( key % 4 == 3) {document.write('<br>')}\
		}\
		var global_memory01 = 0 //First number\
		var global_memory02 = 0 //Second number\
		var global_opperation = '' //Operation\
		function changeMemory(value,var_id) {\
			if(isNaN(value)) {\
				return\
			}\
			if(var_id == 1) {\
				global_memory01 = parseFloat(value)\
			}\
			else if(var_id == 2) {\
				global_memory02 = parseFloat(value)\
			}\
		}\
		function inputbutton(key) {\
			var valid_numbers = \['1','2','3','4','5','6','7','8','9','0'\]\
			var valid_symbols = \['+','-','x','/'\]\
			var display_area = document.getElementById('display_area')\
			var symbol_area = document.getElementById('symbol_area')\
			var value = button_keys\[key\]\
			var as_number = parseFloat(display_area.value)\
			var isnumber = value in valid_numbers\
			var issymbol = (value == '+' || value == '-' || value == 'x' || value == '/')\
			if(value == 'CL') {\
				global_memory01 = 0\
				global_memory02 = 0\
				global_opperation = 0\
				display_area.value = '0'\
				symbol_area.value = ''\
			}\
			else if(value == '.') {\
				if(!display_area.value.includes(value)) {\
					display_area.value = display_area.value + value\
				}\
			}\
			else if(isnumber) {\
				if(display_area.value == '0') {\
					display_area.value = ''\
				}\
				display_area.value = display_area.value + value\
			}\
			else if(issymbol) {\
				if(value == '-' && display_area.value == '')\
					display_area.value = '-' + display_area.value\
				else {\
					if(global_opperation == '') {\
						changeMemory(display_area.value,1)\
					}\
					else {\
						changeMemory(display_area.value,2)\
					}\
					global_opperation = value\
					display_area.value = ''\
					symbol_area.value = global_opperation\
				}\
			}\
			else if(value == 'enter') {\
				changeMemory(display_area.value,2)\
				var answer = 0\
				if (global_opperation == '+') {\
					answer = global_memory01 + global_memory02\
				}\
				else if(global_opperation == '-') {\
					answer = global_memory01 - global_memory02\
				}\
				else if(global_opperation == 'x') {\
					answer = global_memory01 * global_memory02\
				}\
				else if(global_opperation == '/') {\
					answer = global_memory01 / global_memory02\
				}\
				answer = answer.toPrecision(answer.length)\
				display_area.value = answer\
				changeMemory(answer,1)\
				global_memory02 = 0\
				global_opperation = ''\
			}\
		}\
	</script>\
	<head>\
		<style>\
			body{\
				margin:0px;\
				padding:0px;\
			}\
			textarea{\
				resize:none;\
				height:25%;\
				width:90%;\
				text-align:right;\
				font-size:20vh;\
			}\
			textarea.small{\
				width:10%;\
				font-size:10vw;\
				text-align:center;\
			}\
			button{\
				width:25%;\
				height:15%;\
				font-size:5vh;\
			}\
			button.button_type_1{\
				width:25%;\
				height:30%;\
				position: absolute;\
			}\
			button.button_type_2{\
				width:50%;\
				height:15%;\
			}\
			button.button_type_2{\
				width:50%;\
				height:15%;\
			}\
		</style>\
	</head>\
	<body onkeypress='onKeyPress(event)'>\
	</body>\
</html>"

/obj/item/device/calculator/attack_self(var/mob/user)
	user << browse(calculator_data, "window=calculator")