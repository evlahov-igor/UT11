﻿
&НаКлиенте
Процедура ПоказатьЖурнал(Команда)
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Документ = Новый ТекстовыйДокумент;
		Документ.ДобавитьСтроку(ТекДанные.Журнал);
		Документ.Показать(СтрШаблон("Журнал обновления на версию %1. База %2", ТекДанные.Версия, ТекДанные.Магазин));
	КонецЕсли;
КонецПроцедуры
