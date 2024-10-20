﻿////////////////////////////////////////////////////
//// Модуль менеджера регистра сведений "КР_ПриемкаПеремещенийТоваров"
//// Создан: 18.10.2022 Марченко С.Н., КРОК, JIRA№A2105505-702

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура СоздатьПерезаполнитьАктОРасхожденияхПослеПеремещения(Перемещение, Дата, Отказ) Экспорт 
	
	// Ищем введенные на основании акты
	// Если проведенных несколько то генерируем ошибку 
	Запрос = Новый Запрос(ТекстЗапросаНайтиАктОРасхожденияхПослеПеремещения());
	Запрос.УстановитьПараметр("ДокументОснование", Перемещение);
	РезультатЗапроса = Запрос.Выполнить(); 
	
	АктОРасхожденияхПослеПеремещения = Неопределено;
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 
	
	АктОРасхожденияхНайден = Ложь;
	// Выбираем первую запись, если она есть.
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда   		
		АктОРасхожденияхПослеПеремещения = ВыборкаДетальныеЗаписи.Ссылка;  
		АктОРасхожденияхНайден = Истина;
	КонецЕсли;	

	// Проверим на наличие "еще" проведенных документов
	// "Еще" - потому что вторым проведенный после первого не проведенного не может быть 
	//	из за сортировки в запросе
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл    
		
		Если ВыборкаДетальныеЗаписи.Проведен Тогда 
			ТекстОшибки = НСтр("ru = 'Найдено более одного проведенного документа по критериям: "
				"АктОРасхожденияхПослеПеремещения.Товары.ДокументОснование = %1'");  
			ТекстОшибки = СтрШаблон(ТекстОшибки, Перемещение);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , , , Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЦикла;	
	
	Если Не АктОРасхожденияхНайден Тогда 
		ДокументОбъект = Документы.АктОРасхожденияхПослеПеремещения.СоздатьДокумент();  
	Иначе
		ДокументОбъект = АктОРасхожденияхПослеПеремещения.ПолучитьОбъект();
		ДокументОбъект.ПометкаУдаления = Ложь;
		
		Если ДокументОбъект.Проведен Тогда 
			ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЕсли;
		
		КР_ОбщегоНазначениеСервер.ДокументОбъектОчистить(ДокументОбъект); 
		
	КонецЕсли;
	ДокументОбъект.Дата = Дата;
	
	Основание = Новый Структура;
	Основание.Вставить("КР_ЗагружатьКороба", Перемещение);
	ДокументОбъект.Заполнить(Основание);   
	
	АктОРасхожденияхПослеПеремещенияПродолжитьЗаполнение(ДокументОбъект); 
	
	Если Не ДокументОбъект.ПроверитьЗаполнение() Тогда  
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение); 
	
	Если АктОРасхожденияхНайден Тогда 
				
		ТекстОповещения = НСтр("ru = '%1 актуализирован'");  
		ТекстОповещения = СтрШаблон(ТекстОповещения, АктОРасхожденияхПослеПеремещения);
		ОбщегоНазначения.СообщитьПользователю(ТекстОповещения, АктОРасхожденияхПослеПеремещения);
		
	КонецЕсли;     
	
КонецПроцедуры                                                                   

Процедура УдалитьАктОРасхожденияхПослеПеремещения(Перемещение, Отказ) Экспорт 
	
	// Ищем введенные на основании акты
	// Если проведенных несколько то генерируем ошибку 
	Запрос = Новый Запрос(ТекстЗапросаНайтиАктОРасхожденияхПослеПеремещения());
	Запрос.УстановитьПараметр("ДокументОснование", Перемещение);
	РезультатЗапроса = Запрос.Выполнить(); 
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать(); 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл    
		
		Если Не ВыборкаДетальныеЗаписи.ПометкаУдаления Тогда 
			
			ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ДокументОбъект.УстановитьПометкуУдаления(Истина);
			
		КонецЕсли;
		
	КонецЦикла;	
		
КонецПроцедуры                                                                   

#КонецОбласти

#Область ДополнительныеМетоды

Процедура АктОРасхожденияхПослеПеремещенияПродолжитьЗаполнение(ДокументОбъект)

   	ДокументОбъект.Статус = Перечисления.СтатусыАктаОРасхождениях.Отработано;
		
    ДокументОбъект.КР_СкладРазбораРасхождений = 
		Документы.АктОРасхожденияхПослеПеремещения.КР_ПолучитьСкладРазбораРасхождений(ДокументОбъект.СкладОтправитель);
	
	// Заполнить расхождения                                      
	ИспользоватьОрдернуюСхемуСкладПолучатель = СкладыСервер.ИспользоватьОрдернуюСхемуПриПоступлении(
		ДокументОбъект.СкладПолучатель, ДокументОбъект.Дата, Ложь);	
	МенеджерДокумента = Документы.АктОРасхожденияхПослеПеремещения;
	МенеджерДокумента.КР_ЗаполнитьПоПриемкеСервер(ДокументОбъект, МенеджерДокумента.ПараметрыУказанияСерий(ДокументОбъект), 
		ИспользоватьОрдернуюСхемуСкладПолучатель);     
				
	ПараметрыПересчетаСуффикс = "ПоДокументу";
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковокСуффикс", ПараметрыПересчетаСуффикс);		
				
	// Устанавливаем действия при расхождениях    
	ВариантыДействий = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки;
	ПереместитьСоСкладаРазбора = ВариантыДействий.КР_ПереместитьСоСкладаРазбора;
	ПереместитьНаСкладРазбора = ВариантыДействий.КР_ПереместитьНаСкладРазбора;
	Для Каждого СтрокаДанных Из ДокументОбъект.Товары Цикл
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаДанных, СтруктураДействий, Неопределено);  
		
		Если СтрокаДанных.КоличествоПоДокументу < СтрокаДанных.Количество Тогда 
			СтрокаДанных.Действие = ПереместитьСоСкладаРазбора;
		ИначеЕсли СтрокаДанных.КоличествоПоДокументу > СтрокаДанных.Количество Тогда 
			СтрокаДанных.Действие = ПереместитьНаСкладРазбора;
		КонецЕсли;	
		
	КонецЦикла;	
		
КонецПроцедуры

#Область ТекстыЗапросов

Функция ТекстЗапросаНайтиАктОРасхожденияхПослеПеремещения()

	Возврат 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.Ссылка КАК Ссылка,
	|	Т.Ссылка.Проведен КАК Проведен,
	|	Т.Ссылка.ПометкаУдаления КАК ПометкаУдаления
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПеремещения.Товары КАК Т
	|ГДЕ
	|	Т.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Проведен УБЫВ";
	
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли
