﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	КаталогДляСохраненияДанных = ИнтеграцияС1СДокументооборотВызовСервера.ЛокальныйКаталогФайлов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения(
		"ПутьККаталогуНачалоВыбораПослеПодключенияРасширения", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбораПослеПодключенияРасширения(Подключено, ПараметрыОповещения) Экспорт
	
	Если Подключено Тогда
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = КаталогДляСохраненияДанных;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к каталогу для временных файлов'");
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения(
			"ПутьККаталогуНачалоВыбораПослеДиалогаВыбораФайла", ЭтотОбъект));
			
	Иначе // веб-клиент без расширение
		
		ПоказатьПредупреждение(,
			НСтр("ru = 'Для выбора каталога в веб-клиенте необходимо установить расширение для работы с файлами.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбораПослеДиалогаВыбораФайла(ВыбранныеФайлы, ПараметрыОповещения) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		КаталогДляСохраненияДанных = ВыбранныеФайлы[0];
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ИнтеграцияС1СДокументооборотВызовСервера.СохранитьЛокальныйКаталогФайлов(КаталогДляСохраненияДанных);
	Закрыть(КаталогДляСохраненияДанных);
	
КонецПроцедуры

#КонецОбласти
