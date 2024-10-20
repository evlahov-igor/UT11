﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасхожденияСервер.УправлениеСтраницамиВыборДействия(ЭтотОбъект, Параметры);
	
	ИспользоватьЗаказыПоставщикам = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам");
	КоличествоУпаковокРасхождения = Параметры.КоличествоУпаковокРасхождения;
	ГрупповоеИзменение = Параметры.ГрупповоеИзменение;
	
	Если Параметры.ВыбранноеДействие = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы
		Или (Параметры.Свойство("ДействиеНедостачи")
			И Параметры.ДействиеНедостачи = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы) Тогда
		ЗаЧейСчет = ?(Параметры.ПоВинеСтороннейКомпании, "ПоВинеСтороннейКомпании", "ЗаНашСчет");
	КонецЕсли;
	
	Если Не ГрупповоеИзменение Тогда
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			
			Элементы.Страницы.ТекущаяСтраница = Элементы.Излишки;
			ДействиеИзлишки                   = Параметры.ВыбранноеДействие;
			
			Если Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа
				Или Параметры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга Тогда
				Если ДействиеИзлишки = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОформитьПерепоставленноеИВернуть Тогда
					ДействиеИзлишки = Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ПустаяСсылка();
				КонецЕсли;
				Элементы.ОформитьПерепоставленноеИВернуть.Доступность = Ложь;
			КонецЕсли;
			
		Иначе
			Элементы.Страницы.ТекущаяСтраница = Элементы.Недостачи;
			ДействиеНедостачи = Параметры.ВыбранноеДействие;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ГрупповоеИзменение Тогда
		Если КоличествоУпаковокРасхождения >= 0 Тогда
			Элементы.Недостачи.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать излишек'");
		Иначе
			Элементы.Излишки.Видимость = Ложь;
			Заголовок = НСтр("ru='Как отработать недостачу'");
		КонецЕсли;
	Иначе
		Заголовок = НСтр("ru='Как отработать расхождения'");
	КонецЕсли;
	
	АктПриемкиНаХранение = Параметры.ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение
							Или Параметры.ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтХранителя;
	
	Элементы.ПоВинеСтороннейКомпании.Видимость          = Не АктПриемкиНаХранение;
	Элементы.ПоВинеСтороннейКомпанииДекорация.Видимость = Не АктПриемкиНаХранение;
	
	Элементы.КартинкаПояснения.Видимость = Параметры.ПоказыватьПояснение;
	Элементы.Пояснение.Видимость         = Параметры.ПоказыватьПояснение;
	
	СформироватьЗаголовки(Параметры.ТипАкта,
						Параметры.КоличествоУпаковокРасхождения,
						Параметры.СпособОтраженияРасхождений,
						Параметры.ГрупповоеИзменение,
						Параметры.СтрокаПоЗаказу);
						
	// << 17.01.2024 Марченко С.Н., КРОК, JIRA№A2105505-2597
	КР_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	// >> 17.01.2024 Марченко С.Н., КРОК, JIRA№A2105505-2597					

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
		               НСтр("ru='Выполненные изменения будут утеряны. Все равно закрыть?'"),
		               РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаНашСчетПриИзменении(Элемент)
	
	ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоВинеСтороннейКомпанииПриИзменении(Элемент)
	
	ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачуПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьНедостачуИОжидатьДопоставкуПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОжидатьДопоставкуБезОформленияПриИзменении(Элемент)
	
	ДействиеНедостачиПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	
	ПараметрыЗакрытия = Новый Структура();
	ПараметрыЗакрытия.Вставить("ДействиеИзлишки", Неопределено);
	ПараметрыЗакрытия.Вставить("ДействиеНедостачи", Неопределено);
	ПараметрыЗакрытия.Вставить("ПоВинеСтороннейКомпании", Истина);
	
	Если ГрупповоеИзменение Тогда
		
		ПараметрыЗакрытия.ДействиеИзлишки   = ДействиеИзлишки;
		ПараметрыЗакрытия.ДействиеНедостачи = ДействиеНедостачи;
		ПараметрыЗакрытия.ПоВинеСтороннейКомпании = ПоВинеСтороннейКомпании();
		
	ИначеЕсли КоличествоУпаковокРасхождения > 0 Тогда
		
		ПараметрыЗакрытия.ДействиеИзлишки = ДействиеИзлишки;

	ИначеЕсли КоличествоУпаковокРасхождения < 0 Тогда
		
		ПараметрыЗакрытия.ДействиеНедостачи = ДействиеНедостачи;
		ПараметрыЗакрытия.ПоВинеСтороннейКомпании = ПоВинеСтороннейКомпании();
		
	КонецЕсли;
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ВыполняетсяЗакрытие = Истина;
	Закрыть(Неопределено);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьЗаголовки(ТипАкта, КоличествоУпаковокРасхождения, СпособОтраженияРасхождений, ГрупповоеИзменение, СтрокаПоЗаказу)
	
	Если ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПриобретениеТоваровУслуг
		Или ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение Тогда
		
		// Недостачи
		Элементы.ГруппаНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при поступлении согласованы с поставщиком'");
		Элементы.ГруппаНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при поступлении не согласованы с поставщиком'");
		
		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ИсправлениеПервичныхДокументов Тогда
			Если СтрокаПоЗаказу Или (ГрупповоеИзменение И ИспользоватьЗаказыПоставщикам) Тогда
				Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа'");
			Иначе
				Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар'");
			КонецЕсли;
			Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар с последующим оформлением нового поступления недопоставленного товара'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ОформлениеКорректировокПоступления Тогда
			Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка поступления'");
			Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'На недопоставленный товар оформляется корректировка поступления с последующим оформлением нового поступления недопоставленного товара'");
		КонецЕсли;
		
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар принимается на склад, документы не переоформляются'");
		
		// Излишки
		Элементы.ГруппаИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при поступлении согласованы с поставщиком'");
		Элементы.ГруппаИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при поступлении не согласованы с поставщиком'");

		Если СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ИсправлениеПервичныхДокументов Тогда
			Элементы.ОформитьПерепоставленноеДекорация.Заголовок = НСтр("ru = 'Поступление увеличивается на перепоставленный товар'");
			Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок = НСтр("ru = 'Поступление увеличивается на перепоставленный товар с последующим оформлением возврата перепоставленного товара'");
		ИначеЕсли СпособОтраженияРасхождений = Перечисления.СпособыОтраженияАктовОРасхожденияПослеПоступления.ОформлениеКорректировокПоступления Тогда
			Элементы.ОформитьПерепоставленноеДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка поступления'");
			Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок = НСтр("ru = 'На перепоставленный товар оформляется корректировка поступления с последующим оформлением возврата перепоставленного товара'");
		КонецЕсли;
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар оприходуется, относится на прочие доходы, документы не переоформляются'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок  = НСтр("ru = 'Перепоставленный товар отгружается со склада, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтКлиента Тогда
		
		// Недостачи
		Элементы.ГруппаНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при возврате согласованы с клиентом'");
		Элементы.ГруппаНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при возврате не согласованы с клиентом'");
		
		Элементы.ОформитьНедостачуДекорация.Заголовок                   = НСтр("ru = 'Возврат товаров от клиента уменьшается на недопоставленный товар'");
		Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'Возврат товаров от клиента уменьшается на недопоставленный товар с последующим оформлением нового возврата недопоставленного товара'");
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок      = НСтр("ru = 'Недопоставленный товар принимается на склад, документы не переоформляются'");
		
		// Излишки
		Элементы.ГруппаИзлишкиСогласованы.Заголовок = НСтр("ru = 'Излишки при возврате согласованы с поставщиком'");
		Элементы.ГруппаИзлишкиНеСогласованы.Заголовок  = НСтр("ru = 'Излишки при возврате не согласованы с поставщиком'");
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок  = НСтр("ru = 'Излишки возврата оприходуются, относятся на прочие доходы, документы не переоформляются'");
		Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок       = НСтр("ru = 'Возврат товаров от клиента увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара'");
		Элементы.ОформитьПерепоставленноеДекорация.Заголовок               = НСтр("ru = 'Возврат товаров от клиента увеличивается на перепоставленный товар'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок   = НСтр("ru = 'Перепоставленный товар отгружается со склада, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение Тогда
		
		// Недостачи
		Элементы.ГруппаНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при поступлении согласованы с поставщиком'");
		Элементы.ГруппаНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при поступлении не согласованы с поставщиком'");
		
		Если СтрокаПоЗаказу Или (ГрупповоеИзменение И ИспользоватьЗаказыПоставщикам) Тогда
			Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар с последующей отменой недопоставленных строк заказа'");
		Иначе
			Элементы.ОформитьНедостачуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар'");
		КонецЕсли;
		
		Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'Поступление уменьшается на недопоставленный товар с последующим оформлением нового поступления недопоставленного товара'");
		
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок = НСтр("ru = 'Недопоставленный товар принимается на склад, документы не переоформляются'");
		
		// Излишки
		Элементы.ГруппаИзлишкиСогласованы.Заголовок   = НСтр("ru = 'Излишки при поступлении согласованы с поставщиком'");
		Элементы.ГруппаИзлишкиНеСогласованы.Заголовок = НСтр("ru = 'Излишки при поступлении не согласованы с поставщиком'");
		
		Элементы.ОформитьПерепоставленноеДекорация.Заголовок = НСтр("ru = 'Поступление увеличивается на перепоставленный товар'");
		Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок = НСтр("ru = 'Поступление увеличивается на перепоставленный товар с последующим оформлением отгрузки перепоставленного товара'");
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок = НСтр("ru = 'Перепоставленный товар оприходуется, документы не переоформляются'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок  = НСтр("ru = 'Перепоставленный товар отгружается со склада, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтХранителя Тогда
		
		// Недостачи
		Элементы.ГруппаНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при поступлении согласованы с хранителем'");
		Элементы.ГруппаНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при поступлении не согласованы с хранителем'");
		
		Элементы.ОформитьНедостачуДекорация.Заголовок                   = НСтр("ru = 'Поступление товаров от хранителя уменьшается на недопоставленный товар'");
		Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'Поступление товаров от хранителя уменьшается на недопоставленный товар с последующим оформлением нового поступления недопоставленного товара'");
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок      = НСтр("ru = 'Недопоставленный товар принимается на склад, документы не переоформляются'");
		
		// Излишки
		Элементы.ГруппаИзлишкиСогласованы.Заголовок = НСтр("ru = 'Излишки при поступлении согласованы с хранителем'");
		Элементы.ГруппаИзлишкиНеСогласованы.Заголовок  = НСтр("ru = 'Излишки при возврате не согласованы с хранителем'");
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок  = НСтр("ru = 'Излишки поступления товаров от хранителя оприходуются, относятся на прочие доходы, документы не переоформляются'");
		Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок       = НСтр("ru = 'Поступление товаров от хранителя увеличивается на перепоставленный товар с последующим оформлением передачи перепоставленного товара'");
		Элементы.ОформитьПерепоставленноеДекорация.Заголовок               = НСтр("ru = 'Поступление товаров от хранителя увеличивается на перепоставленный товар'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок   = НСтр("ru = 'Перепоставленный товар отгружается со склада, документы не переоформляются'");
		
	ИначеЕсли ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратОтКомиссионера Тогда
		
		// Недостачи
		Элементы.ГруппаНедостачиСогласованы.Заголовок   = НСтр("ru = 'Недостачи при поступлении согласованы с комиссионером'");
		Элементы.ГруппаНедостачиНеСогласованы.Заголовок = НСтр("ru = 'Недостачи при поступлении не согласованы с комиссионером'");
		
		Элементы.ОформитьНедостачуДекорация.Заголовок                   = НСтр("ru = 'Поступление товаров от комиссионера уменьшается на недопоставленный товар'");
		Элементы.ОформитьНедостачуИОжидатьДопоставкуДекорация.Заголовок = НСтр("ru = 'Поступление товаров от комиссионера уменьшается на недопоставленный товар с последующим оформлением нового поступления недопоставленного товара'");
		Элементы.ОжидатьДопоставкуБезОформленияДекорация.Заголовок      = НСтр("ru = 'Недопоставленный товар принимается на склад, документы не переоформляются'");
		
		// Излишки
		Элементы.ГруппаИзлишкиСогласованы.Заголовок = НСтр("ru = 'Излишки при поступлении согласованы с комиссионером'");
		Элементы.ГруппаИзлишкиНеСогласованы.Заголовок  = НСтр("ru = 'Излишки при возврате не согласованы с комиссионером'");
		
		Элементы.ОтнестиПерепоставленноеНаПрочиеДоходыДекорация.Заголовок  = НСтр("ru = 'Излишки поступления товаров от комиссионера оприходуются, относятся на прочие доходы, документы не переоформляются'");
		Элементы.ОформитьПерепоставленноеИВернутьДекорация.Заголовок       = НСтр("ru = 'Поступление товаров от комиссионера увеличивается на перепоставленный товар с последующим оформлением поступления перепоставленного товара'");
		Элементы.ОформитьПерепоставленноеДекорация.Заголовок               = НСтр("ru = 'Поступление товаров от комиссионера увеличивается на перепоставленный товар'");
		Элементы.ВернутьПерепоставленноеБезОформленияДекорация.Заголовок   = НСтр("ru = 'Перепоставленный товар отгружается со склада, документы не переоформляются'");
		
		
	КонецЕсли;
	
	АктПриемкиНаХранение = ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение
							Или ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтХранителя
							Или ТипАкта = Перечисления.ТипыОснованияАктаОРасхождении.ВозвратОтКомиссионера;
	
	Если АктПриемкиНаХранение Тогда
		ЗначениеСписания = Элементы.ЗаНашСчет.СписокВыбора.Получить(0);
		ЗначениеСписания.Представление = НСтр("ru = 'Списать недостачи'");
	КонецЕсли;
	
	ЗаголовокОформленияНедостачЗаНашСчет = ?(АктПриемкиНаХранение,
											НСтр("ru = 'Недостающий товар будет оприходован на склад и списан на недостачи'"),
											НСтр("ru = 'Недостающий товар будет оприходован на склад и списан на прочие расходы'"));
	
	Элементы.ЗаНашСчетДекорация.Заголовок               = ЗаголовокОформленияНедостачЗаНашСчет;
	Элементы.ПоВинеСтороннейКомпанииДекорация.Заголовок = НСтр("ru = 'Недостающий товар будет оприходован на склад и списан на прочие расходы. Ответственность за недостачи будет возложена на стороннюю компанию'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПоВинеСтороннейКомпании()

	Возврат ?(ДействиеНедостачи = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы"),
	                                                      ?(ЗаЧейСчет = "ПоВинеСтороннейКомпании", Истина, Ложь),
	                                                      Ложь);

КонецФункции

&НаКлиенте
Процедура ВариантОтраженияСписанияНаПрочиеРасходыПриИзменении()
	
	ДействиеНедостачи = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы");
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеНедостачиПриИзменении()
	
	ЗаЧейСчет = "";
	
КонецПроцедуры

#КонецОбласти

#Область КР_ДополнительныеПроцедурыИФункции

// << 17.01.2024 Марченко С.Н., КРОК, JIRA№A2105505-2597
&НаСервере
Процедура КР_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	
	#Область КР_ПереместитьНаСкладРазбора  
	
	// Элемент
	ЭлементФормы = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(ЭтотОбъект,
		"ДействиеНедостачи", Элементы.ГруппаНедостачиНеСогласованы); 
	ЭлементФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементФормы.Вид = ВидПоляФормы.ПолеПереключателя;
	СписокВыбора = ЭлементФормы.СписокВыбора;
	СписокВыбора.Добавить(Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.КР_ПереместитьНаСкладРазбора);
	
	// Декорация
	Декорация = КР_МетодыМодификацииФорм.ВставитьДекорациюФормы(ЭтотОбъект,
		"КР_ПереместитьНаСкладРазбораДекорация", Элементы.ГруппаНедостачиНеСогласованы); 
	Декорация.ЦветТекста = ЦветаСтиля["ТекстИнформационнойНадписи"];   
	Декорация.Заголовок = 
		НСтр("ru = 'Недопоставленный товар перемещается на виртуальный склад разбора товарных расхождений'");     
	
	#КонецОбласти
	
	#Область КР_ПереместитьСоСкладаРазбора
	
	// Элемент
	ЭлементФормы = КР_МетодыМодификацииФорм.ВставитьЭлементФормы(ЭтотОбъект,
		"ДействиеИзлишки", Элементы.ГруппаИзлишкиНеСогласованы); 
	ЭлементФормы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ЭлементФормы.Вид = ВидПоляФормы.ПолеПереключателя;
	СписокВыбора = ЭлементФормы.СписокВыбора;
	СписокВыбора.Добавить(Перечисления.ВариантыДействийПоРасхождениямВАктеПослеПриемки.КР_ПереместитьСоСкладаРазбора);
	
	// Декорация
	Декорация = КР_МетодыМодификацииФорм.ВставитьДекорациюФормы(ЭтотОбъект,
		"КР_ПереместитьСоСкладаРазбораДекорация", Элементы.ГруппаИзлишкиНеСогласованы); 
	Декорация.ЦветТекста = ЦветаСтиля["ТекстИнформационнойНадписи"];   
	Декорация.Заголовок = 
		НСтр("ru = 'Перепоставленный товар перемещается с виртуального склада разбора товарных расхождений'");     
	
	#КонецОбласти
	
КонецПроцедуры // >> 17.01.2024 Марченко С.Н., КРОК, JIRA№A2105505-2597

#КонецОбласти
