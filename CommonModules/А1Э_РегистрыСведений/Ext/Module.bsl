﻿#Область НеЗакончено

Функция ЗаписатьВНепериодическийНезависимыйРегистрСведенийНеЗакончено(ТаблицаЗначений, ИмяРегистра) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		ТаблицаЗначений = Новый ТаблицаЗначений;		
	#КонецЕсли 
	МассивИзмерений = Новый Массив;
	РабочаяТаблица = ТаблицаЗначений.Скопировать();
	Для Каждого Измерение ИЗ Метаданные.РегистрыСведений[ИмяРегистра].Измерения Цикл
		МассивИзмерений.Добавить(Измерение.Имя);
	КонецЦикла;
	СтрокаИзмерений = СтрСоединить(МассивИзмерений,",");
	РабочаяТаблица.Свернуть(СтрокаИзмерений);
	Для Каждого Строка Из РабочаяТаблица Цикл
		НаборЗаписей = РегистрыСведений[ИмяРегистра];
	КонецЦикла;
	
КонецФункции

Функция ПолучитьСуществующиеЗаписиРегистра(ТаблицаЗначений, ИмяРегистра) Экспорт
	МассивЗапросов = Новый Массив;
	МассивЗапросов.Добавить(ТекстЗапросаЗагрузкиТаблицыЗначенийВоВременнуюТаблицу(ТаблицаЗначений, "ТаблицаКЗагрузке"));
	
КонецФункции

Функция ТекстЗапросаЗагрузкиТаблицыЗначенийВоВременнуюТаблицу(ТаблицаЗначений, ИмяВременнойТаблицы, ИмяПараметраЗапроса = "ТаблицаЗначений")
	МассивСтрокЗапроса = Новый Массив;
	МассивСтрокЗапроса.Добавить("ВЫБРАТЬ");
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		МассивСтрокЗапроса.Добавить("Таблица." + Колонка.Имя + ",");
	КонецЦикла;
	ПоследняяСтрока = МассивСтрокЗапроса[МассивСтрокЗапроса.Количество() - 1];
	МассивСтрокЗапроса[МассивСтрокЗапроса.Количество() - 1] = Лев(ПоследняяСтрока, СтрДлина(ПоследняяСтрока) - 1);
	МассивСтрокЗапроса.Добавить("ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
	МассивСтрокЗапроса.Добавить("ИЗ &" + ИмяПараметраЗапроса + " КАК Таблица");
	ТекстЗапроса = СтрСоединить(МассивСтрокЗапроса, Символы.ПС);
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстЗапросаПоискаСуществующихЗаписей(ИмяРегистра, ИмяВременнойТаблицы)
	МассивСтрокЗапроса = Новый Массив;	
КонецФункции

Функция МассивИзмерений()
	
КонецФункции 

//Функция ОчиститьНезависимыйРегистр(ИмяРегистра, Отбор) Экспорт
//	//Регистр = РегистрыСведений[ИмяРегистра];
//	//МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
//	//СтруктураЗапроса = А1Э_Запросы.НовыйСтруктураЗапроса();
//	//А1Э_Запросы.ДобавитьИсточникДанных(СтруктураЗапроса, "РегистрСведений." + ИмяРегистра, ИмяРегистра);
//	//Для Каждого Измерение Из Метаданные.Измерения Цикл
//	//	А1Э_Запросы.ДобавитьПоле(СтруктураЗапроса, Измерение.Имя);
//	//КонецЦикла;
//	//Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
//	//	А1Э_Запросы.ДобавитьПоле(СтруктураЗапроса, "Период");
//	//КонецЕсли;
//	////Для Каждого
//	//А1Э_Запросы.ДобавитьУсловие(СтруктураЗапроса, "");
//КонецФункции

#КонецОбласти 

Функция ЗаписатьВНепериодическийНезависимыйРегистрСведений(ТаблицаЗначений, ИмяРегистра) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		ТаблицаЗначений = Новый ТаблицаЗначений;		
	#КонецЕсли
	
	НачатьТранзакцию();
	Для Каждого Строка Из ТаблицаЗначений Цикл
		МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Строка);
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			ОтменитьТранзакцию();
			ВызватьИсключение ОписаниеОшибки;
		КонецПопытки
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	Возврат Истина;
КонецФункции

Функция Очистить(ИмяРегистра, Знач Ключи = Неопределено) Экспорт
	РабочиеКлючи = А1Э_Массивы.Массив(Ключи);
	Если РабочиеКлючи.Количество() = 0 Тогда
		РабочиеКлючи.Добавить(Новый Структура);
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	НачатьТранзакцию();
	Для Каждого Структура Из РабочиеКлючи Цикл
		НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
		Для Каждого Пара Из Структура Цикл
			Если МетаданныеРегистра.Измерения.Найти(Пара.Ключ) = Неопределено Тогда
				Если МетаданныеРегистра.Ресурсы.Найти(Пара.Ключ) = Неопределено И МетаданныеРегистра.Реквизиты.Найти(Пара.Ключ) = Неопределено Тогда
					А1Э_Служебный.СлужебноеИсключение("Неверные ключи в операции очистки регистра - имя ключа не совпадает с измерением или ресурсом");
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли;	
			НаборЗаписей.Отбор[Пара.Ключ].Установить(Пара.Значение);
		КонецЦикла;
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецФункции

Функция ДобавитьЗаписи(ИмяРегистра, Знач МассивДанных) Экспорт
	МассивДанных = А1Э_Массивы.Массив(МассивДанных);
	НачатьТранзакцию();
	Для Каждого СтруктураДанных Из МассивДанных Цикл
		Менеджер = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Менеджер, СтруктураДанных);
		Менеджер.Записать();
	КонецЦикла;
	ЗафиксироватьТранзакцию();
КонецФункции 

Функция ЗначенияКолонкиУникальны(Знач ИмяРегистраИлиНаборЗаписей, Знач ИмяКолонки, Знач ЗначенияДляПроверки = Неопределено) Экспорт
	Если ТипЗнч(ИмяРегистраИлиНаборЗаписей) = Тип("Строка") Тогда
		ИмяРегистра = ИмяРегистраИлиНаборЗаписей;
	Иначе
		ИмяРегистра = ИмяРегистраИлиНаборЗаписей.Метаданные().Имя;
		ЗначенияДляПроверки = ИмяРегистраИлиНаборЗаписей; 
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Таблица.ИмяКолонки КАК Значение,
	|	КОЛИЧЕСТВО(Таблица.ИмяКолонки) КАК Количество
	|ИЗ
	|	ИмяРегистра КАК Таблица
	|ГДЕ
	|	Таблица.ИмяКолонки В(&ЗначенияДляПроверки)
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.ИмяКолонки
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(Таблица.ИмяКолонки) > 1";
	Если ЗначенияДляПроверки = Неопределено Тогда
		А1Э_Строки.Подставить(Запрос.Текст, "Таблица.ИмяИзмерения В(&МассивЗначений)", "ИСТИНА");
	Иначе
		Если ТипЗнч(ЗначенияДляПроверки) <> Тип("Массив") Тогда //Считаем, что у нас НаборЗаписей регистра сведений.
			ЗначенияДляПроверки = ЗначенияДляПроверки.ВыгрузитьКолонку(ИмяКолонки);
		КонецЕсли;
		Запрос.УстановитьПараметр("ЗначенияДляПроверки", ЗначенияДляПроверки);
	КонецЕсли;
	А1Э_Строки.Подставить(Запрос.Текст, "ИмяРегистра", "РегистрСведений." + ИмяРегистра);
	А1Э_Строки.Подставить(Запрос.Текст, "ИмяКолонки", ИмяКолонки);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Истина;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		А1Э_Сообщения.СообщитьПоШаблону("Не пройдена проверка уникальности: в регистре сведений [ИмяРегистра] в колонке [ИмяКолонки] значение [Значение] повторяется [Количество] раз!",
		А1Э_Структуры.Создать(
		"ИмяРегистра", ИмяРегистра,
		"ИмяКолонки", ИмяКолонки,
		"Значение", Выборка.Значение,
		"Количество", Выборка.Количество,
		));
	КонецЦикла;
	Возврат Ложь;
КонецФункции

// Определяет, является ли регистр сведений независимым (или он подчинен регистратору) 
//
// Параметры:
//  Идентификатор	 - Строка,ОбъектМетаданных	 - 
// 
// Возвращаемое значение:
//   - Булево
//
Функция Независимый(Знач Идентификатор) Экспорт
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		ИмяРегистра = Идентификатор.Имя;
	Иначе //ожидается строка.
		ИмяРегистра = А1Э_Строки.После(Идентификатор, ".");
	КонецЕсли;
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	Возврат НЕ А1Э_Общее.Свойство(НаборЗаписей.Отбор, "Регистратор");
КонецФункции

// Создает текст запроса, позволяющий по периодическому регистру создать таблицу, содержащую измерения, ресурсы и поля ДатаНачала, ДатаОкончания.
// Предназначается для исполь
//
// Параметры:
//  Идентификатор		 - Строка,ОбъектМетаданных - объект метаданных регистра сведений или его полное имя.
//  ИмяВременнойТаблицы	 - Строка - имя временной таблицы, куда будут помещены данные.
//  Отборы               - Структура,Неопределено - 
// 
// Возвращаемое значение:
//   - 
//
Функция ТекстЗапросаТаблицыПериодическихДанных(Знач Идентификатор, Знач ИмяВременнойТаблицы, Знач Отборы = Неопределено) Экспорт
	ОбъектМетаданных = А1Э_Метаданные.ОбъектМетаданных(Идентификатор);
	Если А1Э_Метаданные.ТипМетаданных(ОбъектМетаданных) <> "РегистрСведений" Тогда
		А1Э_Служебный.СлужебноеИсключение("Временная таблица данных по периодам может быть построена только для периодического регистра сведений!");
	ИначеЕсли А1Э_Общее.РавноОдномуИз(ОбъектМетаданных.ПериодичностьРегистраСведений,
		Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический, Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.ПозицияРегистратора) Тогда
		А1Э_Служебный.СлужебноеИсключение("Временная таблица данных по периодам может быть построена только для периодического регистра сведений!");
	КонецЕсли;
	
	ТекстЗапроса =  
	"ВЫБРАТЬ
	|	&НачалоПериода КАК Период,
	|	А1Э_РегистрСведенийЗамена.Измерения КАК Измерения,
	|	А1Э_РегистрСведенийЗамена.Ресурсы КАК Ресурсы
	|ПОМЕСТИТЬ А1Э_РегистрыСведений_ДанныеДляРасчетаТаблицыПериодическихДанных
	|ИЗ
	|	&ИмяРегистраСрезПоследнихНачалоПериода КАК А1Э_РегистрСведенийЗамена
	|ГДЕ
	|	&Отборы
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	А1Э_РегистрСведенийЗамена.Период,
	|	А1Э_РегистрСведенийЗамена.Измерения,
	|	А1Э_РегистрСведенийЗамена.Ресурсы
	|ИЗ
	|	&ИмяРегистра КАК А1Э_РегистрСведенийЗамена
	|ГДЕ
	|	&Отборы
	|	И А1Э_РегистрСведенийЗамена.Период >= &НачалоПериода
	|	И А1Э_РегистрСведенийЗамена.Период < &ОкончаниеПериода
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Измерения,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	А1Э_РегистрСведенийЗамена.Период КАК ДатаНачала,
	|	ЕСТЬNULL(МИНИМУМ(А1Э_СледующиеДанные.Период), &ОкончаниеПериода) КАК ДатаОкончания,
	|	А1Э_РегистрСведенийЗамена.Измерения КАК Измерения,
	|	А1Э_РегистрСведенийЗамена.Ресурсы КАК Ресурсы
	|ПОМЕСТИТЬ ИмяВременнойТаблицы
	|ИЗ
	|	А1Э_РегистрыСведений_ДанныеДляРасчетаТаблицыПериодическихДанных КАК А1Э_РегистрСведенийЗамена
	|		ЛЕВОЕ СОЕДИНЕНИЕ А1Э_РегистрыСведений_ДанныеДляРасчетаТаблицыПериодическихДанных КАК А1Э_СледующиеДанные
	|		ПО (&СравнениеИзмерений)
	|			И А1Э_РегистрСведенийЗамена.Период < А1Э_СледующиеДанные.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	А1Э_РегистрСведенийЗамена.Период,
	|	А1Э_РегистрСведенийЗамена.Измерения,
	|	А1Э_РегистрСведенийЗамена.Ресурсы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Измерения,
	|	ДатаНачала,
	|	ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ А1Э_РегистрыСведений_ДанныеДляРасчетаТаблицыПериодическихДанных";
	МассивЗаменаИзмерений = Новый Массив;
	МассивЗаменаИзмеренийССинонимами = Новый Массив;
	МассивСравнениеИзмерений = Новый Массив;
	МассивИзмерений = Новый Массив;
	Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		МассивЗаменаИзмерений.Добавить("А1Э_РегистрСведенийЗамена." + Измерение.Имя);
		МассивЗаменаИзмеренийССинонимами.Добавить("А1Э_РегистрСведенийЗамена." + Измерение.Имя + " КАК " + Измерение.Имя);	
		МассивСравнениеИзмерений.Добавить("А1Э_РегистрСведенийЗамена." + Измерение.Имя + " = А1Э_СледующиеДанные." + Измерение.Имя); 
		МассивИзмерений.Добавить(Измерение.Имя);
	КонецЦикла;
	А1Э_Строки.Подставить(ТекстЗапроса, "А1Э_РегистрСведенийЗамена.Измерения КАК Измерения", СтрСоединить(МассивЗаменаИзмеренийССинонимами, "," + Символы.ПС + Символы.Таб)); 	
	А1Э_Строки.Подставить(ТекстЗапроса, "А1Э_РегистрСведенийЗамена.Измерения", СтрСоединить(МассивЗаменаИзмерений, "," + Символы.ПС + Символы.Таб));
	А1Э_Строки.Подставить(ТекстЗапроса, "&СравнениеИзмерений", СтрСоединить(МассивСравнениеИзмерений, Символы.ПС + Символы.Таб + "И "));
	А1Э_Строки.Подставить(ТекстЗапроса, "Измерения", СтрСоединить(МассивИзмерений, "," + Символы.ПС + Символы.Таб)); 
	МассивЗаменаРесурсов = Новый Массив;
	МассивЗаменаРесурсовССинонимами = Новый Массив;
	Для Каждого Ресурс Из ОбъектМетаданных.Ресурсы Цикл
		МассивЗаменаРесурсов.Добавить("А1Э_РегистрСведенийЗамена." + Ресурс.Имя);
		МассивЗаменаРесурсовССинонимами.Добавить("А1Э_РегистрСведенийЗамена." + Ресурс.Имя + " КАК " + Ресурс.Имя);
	КонецЦикла;
	А1Э_Строки.Подставить(ТекстЗапроса, "А1Э_РегистрСведенийЗамена.Ресурсы КАК Ресурсы", СтрСоединить(МассивЗаменаРесурсовССинонимами, "," + Символы.ПС + Символы.Таб));
	А1Э_Строки.Подставить(ТекстЗапроса, "А1Э_РегистрСведенийЗамена.Ресурсы", СтрСоединить(МассивЗаменаРесурсов, "," + Символы.ПС + Символы.Таб));
	
	ИмяРегистра = ОбъектМетаданных.ПолноеИмя(); 
	А1Э_Строки.Подставить(ТекстЗапроса, "&ИмяРегистраСрезПоследнихНачалоПериода", ИмяРегистра + ".СрезПоследних(&НачалоПериода)");
	А1Э_Строки.Подставить(ТекстЗапроса, "&ИмяРегистра", ИмяРегистра);
	
	МассивУсловий = Новый Массив;
	Если Отборы <> Неопределено Тогда
		Для Каждого Пара Из Отборы Цикл
			МассивУсловий.Добавить("А1Э_РегистрСведенийЗамена." + Пара.Ключ + " = " + А1Э_Запросы.СтрокаЗначения(Пара.Значение));	
		КонецЦикла;
	КонецЕсли;
	А1Э_Запросы.ПодставитьУсловие(ТекстЗапроса, "&Отборы", МассивУсловий); 
	
	А1Э_Запросы.УстановитьВременнуюТаблицу(ТекстЗапроса, ИмяВременнойТаблицы);
	Возврат ТекстЗапроса;
КонецФункции
