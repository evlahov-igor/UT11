﻿
Процедура ПередУдалением(Отказ)
	
	// Отключение механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
	Если Не Этотобъект.ДополнительныеСвойства.Свойство("НеВыполнятьКонтрольУдаляемых") Тогда
		Сообщить("Непосредственное удаление запрещено, могут остаться битые ссылки!");
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ) 
	
	// Отключение механизма регистрации объектов.
	ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	
КонецПроцедуры
