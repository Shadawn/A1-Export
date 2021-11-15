﻿Функция Исполнить(ДанныеДляЗапроса, ПараметрыЗапроса = Неопределено) Экспорт
	Запрос = Запрос(ДанныеДляЗапроса, ПараметрыЗапроса);
	Возврат Запрос.Выполнить();
КонецФункции 

Функция ПервыйРезультат(ДанныеДляЗапроса, ПараметрыЗапроса = Неопределено, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Результат = Исполнить(ДанныеДляЗапроса, ПараметрыЗапроса);
	Если Результат.Колонки.Количество() < 1 Тогда
		А1Э_Служебный.СлужебноеИсключение("В результате запроса должен быть хотя бы одно поле!");
	КонецЕсли;
	ИмяПоля = Результат.Колонки[0].Имя;
	Если Результат.Пустой() Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка[ИмяПоля];
КонецФункции

Функция Запрос(ДанныеДляЗапроса, Параметры = Неопределено) Экспорт
	Если А1Э_Классы.Класс(ДанныеДляЗапроса) = А1Э_Классы.ДанныеЗапроса() Тогда
		Запрос = Новый Запрос(ДанныеДляЗапроса.Текст);
		ПодставитьПараметрыВЗапрос(Запрос, ДанныеДляЗапроса.Параметры);
	ИначеЕсли ТипЗнч(ДанныеДляЗапроса) = Тип("Запрос") Тогда
		Запрос = ДанныеДляЗапроса;
	ИначеЕсли ТипЗнч(ДанныеДляЗапроса) = Тип("Строка") Тогда
		Запрос = Новый Запрос(ДанныеДляЗапроса);
		ПодставитьПараметрыВЗапрос(Запрос, Параметры);
	Иначе
		А1Э_Служебный.СлужебноеИсключение("Запрос может быть сформировать только из запроса или объекта класса ДанныеЗапроса!");
	КонецЕсли;
	
	Возврат Запрос;
КонецФункции

Функция Выбрать(ДанныеДляЗапроса, Параметры = Неопределено) Экспорт
	Возврат Исполнить(ДанныеДляЗапроса, Параметры).Выбрать();	
КонецФункции

Функция ПодставитьСтроку(ТекстЗапроса, СтрокаПоиска, СтрокаЗамены) Экспорт
	СтрокаДляЗамены = """" + СтрЗаменить(СтрокаЗамены, """", """""") + """";
	А1Э_Строки.Подставить(ТекстЗапроса, СтрокаПоиска, СтрокаДляЗамены);
КонецФункции

// Шаблон - это строка, в которой точки заменены на "___" (три "_") и которая может начинаться с "&". 
// Функция заменяет такие строки обратно на то, что выполняется движком запроса и отрезает первый "&".
// Функция используется для того, чтобы писать читаемые и открываемые конструктором запросы к данным других расширений. 
//
// Параметры:
//  ТекстЗапроса - Строка -  
//  Шаблон		 - Строка - 
// 
// Возвращаемое значение:
//  ТекстЗапроса - Строка
//
Функция ПодставитьШаблон(ТекстЗапроса, Шаблон) Экспорт 
	Подстановка = СтрЗаменить(Шаблон, "___", ".");
	Если СтрНачинаетсяС(Подстановка, "&") Тогда
		Подстановка = Сред(Подстановка, 2);
	КонецЕсли;
	А1Э_Строки.Подставить(ТекстЗапроса, Шаблон, Подстановка);
КонецФункции

// Заменяет строку поиска на условия, соединенные И. Если условий нет, заменяет на ИСТИНА
//
// Параметры:
//  ТекстЗапроса - Строка - 
//  СтрокаПоиска - Строка - 
//  Условие		 - Массив - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПодставитьУсловие(ТекстЗапроса, СтрокаПоиска, Условие) Экспорт
	Если Условие.Количество() = 0 Тогда
		СтрокаЗамены = "ИСТИНА"
	Иначе
		СтрокаЗамены = СтрСоединить(Условие, " И ");
	КонецЕсли;
	А1Э_Строки.Подставить(ТекстЗапроса, СтрокаПоиска, "(" + СтрокаЗамены + ")");
КонецФункции

// Устанавливает временную таблицу в тексте запроса. 
// В тексте должен присутствовать идентификатор "ПОМЕСТИТЬ ИмяВременнойТаблицы".
// Если ИмяВременнойТаблицы не заполнено, идентификатор удаляется (запрос выполняется без помещения во временную таблицу).
//
// Параметры:
//  ТекстЗапроса		 - Строка - 
//  ИмяВременнойТаблицы	 - Строка - 
// 
// Возвращаемое значение:
//   - 
//
Функция УстановитьВременнуюТаблицу(ТекстЗапроса, ИмяВременнойТаблицы) Экспорт
	Если НЕ ЗначениеЗаполнено(ИмяВременнойТаблицы) Тогда
		А1Э_Строки.Подставить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяВременнойТаблицы", "");  
	Иначе
		А1Э_Строки.Подставить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяВременнойТаблицы", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
	КонецЕсли;
КонецФункции

// Соединяет тексты запроса, чтобы выполнить их пакетным запросом.
//
// Параметры:
//  МассивЧастейЗапроса	 - Массив - элементы: Строка. 
// 
// Возвращаемое значение:
//  Итоговый текст запроса - Строка
//
Функция Соединить(МассивЧастейЗапроса) Экспорт 
	Возврат СтрСоединить(МассивЧастейЗапроса, РазделительЗапроса());
КонецФункции

// Объединяет тексты запросов, чтобы выполнить их одним запросом с оператором ОБЪЕДИНИТЬ
//
// Параметры:
//  МассивЧастейЗапроса	 - Массив - элементы: Строка. 
//  ОбъединитьВсе		 - Булево - 
// 
// Возвращаемое значение:
//   - 
//
Функция Объединить(МассивЧастейЗапроса, ОбъединитьВсе = Истина) Экспорт
	Если ОбъединитьВсе = Истина Тогда
		Объединитель = "ОБЪЕДИНИТЬ ВСЕ"
	Иначе
		Объединитель = "ОБЪЕДИНИТЬ"
	КонецЕсли;
	Объединитель = Символы.ПС + Объединитель + Символы.ПС;
	Возврат СтрСоединить(МассивЧастейЗапроса, Объединитель);
КонецФункции

// Возвращает строку, которая при подстановке в текст запроса будет эквивалентна переданному значению.
//
// Параметры:
//  Значение - Строка,Число,Дата - если значение является строкой и начинается с &, то оно рассматриватся как параметр запроса и не обрабатывается.
// 
// Возвращаемое значение:
//   - 
//
Функция СтрокаЗначения(Значение) Экспорт
	Тип = ТипЗнч(Значение);
	Если Тип = Тип("Строка") Тогда
		Если СтрНачинаетсяС(Значение, "&") Тогда
			Возврат Значение;
		Иначе
			Возврат """" + СтрЗаменить(Значение, """", """""") + """";
		КонецЕсли;
	ИначеЕсли Тип = Тип("Число") Тогда
		Возврат СтрЗаменить(Формат(Значение, "ЧРГ="""";ЧДЦ=""."""), Символы.НПП, "");
	ИначеЕсли Тип = Тип("Дата") Тогда
		ЧастиДаты = А1Э_Массивы.Создать(Год(Значение), Месяц(Значение), День(Значение), Час(Значение), Минута(Значение), Секунда(Значение));  
		Возврат СтрЗаменить("ДАТАВРЕМЯ(" + СтрСоединить(ЧастиДаты, ", ") + ")", Символы.НПП, "");
	Иначе
		А1Э_Служебный.ИсключениеНеверныйТип("Значение", ИмяМодуля() + ".СтрокаЗначения", Значение, "Строка,Число,Дата"); 
	КонецЕсли;	
КонецФункции

#Область СборкаЗапросов

#Область Декларации

Функция НоваяСборкаЗапроса()
	НоваяСборкаЗапроса = Новый Массив;
	НоваяСборкаЗапроса.Добавить(НовыйСтруктураЗапроса("ВЫБРАТЬ"));
	Возврат НоваяСборкаЗапроса;
КонецФункции 

Функция НовыйСтруктураЗапроса(Ключ = "ВЫБРАТЬ", ИмяВременнойТаблицы = "") Экспорт 
	Если ЗначенияКлючейЗапроса().Найти(Ключ) = Неопределено Тогда
		А1Э_Служебный.СлужебноеИсключение("Неверный ключ запроса!");
	КонецЕсли;
	
	СтруктураЗапроса = Новый Структура;
	СтруктураЗапроса.Вставить("Класс", А1Э_Классы.СтруктураЗапроса());
	СтруктураЗапроса.Вставить("Ключ", Ключ);
	СтруктураЗапроса.Вставить("Поля", Новый Массив);
	СтруктураЗапроса.Вставить("ИмяВременнойТаблицы", ИмяВременнойТаблицы);
	СтруктураЗапроса.Вставить("ИсточникиДанных", Новый Массив);
	СтруктураЗапроса.Вставить("Отбор", НовыйОтборЗапроса());
	Возврат СтруктураЗапроса;
КонецФункции

Функция НовыйПолеЗапроса(Имя, Текст = "", Группировка = "") Экспорт
	Возврат Новый Структура("Класс,Имя,Текст,Группировка", А1Э_Классы.ПолеЗапроса(), Имя, Текст, Группировка);
КонецФункции

Функция НовыйИсточникДанныхЗапроса(Имя, ИсточникДанных, Соединения = Неопределено) Экспорт
	ИсточникДанныхЗапроса =  Новый Структура("Класс", А1Э_Классы.ИсточникДанныхЗапроса());
	ИсточникДанныхЗапроса.Вставить("Имя", Имя);
	ИсточникДанныхЗапроса.Вставить("ИсточникДанных", ИсточникДанных);
	ИсточникДанныхЗапроса.Вставить("Соединения", А1Э_Массивы.Массив(Соединения));
	
	Возврат ИсточникДанныхЗапроса;
КонецФункции

Функция НовыйСоединениеЗапроса(ИсточникДанных, Тип = "ЛЕВОЕ", Условие = "ИСТИНА") Экспорт
	Если ЗначенияТиповСоединений().Найти(Тип) = Неопределено Тогда
		А1Э_Служебный.СлужебноеИсключение("Неверный тип соединения запроса!");
	КонецЕсли;
	Возврат Новый Структура("Класс,Тип,ИсточникДанных,Условие",А1Э_Классы.СоединениеЗапроса(), Тип, ИсточникДанных, Условие);		
КонецФункции

Функция ЗначенияКлючейЗапроса()
	Возврат А1Э_Массивы.Создать("ВЫБРАТЬ", "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "УНИЧТОЖИТЬ");
КонецФункции

Функция ЗначенияТиповСоединений()
	Возврат	А1Э_Массивы.Создать("ЛЕВОЕ", "ПРАВОЕ", "ВНУТРЕННЕЕ", "ПОЛНОЕ");
КонецФункции

Функция НовыйОтборЗапроса(СвязьУсловий = "И") Экспорт
	Если ЗначенияСвязейУсловий().Найти(СвязьУсловий) = Неопределено Тогда
		А1Э_Служебный.СлужебноеИсключение("Неверная связь условий!");
	КонецЕсли;
	
	ОтборЗапроса = Новый Структура;
	ОтборЗапроса.Вставить("Класс", А1Э_Классы.ОтборЗапроса());
	ОтборЗапроса.Вставить("Сравнения", Новый Массив);
	ОтборЗапроса.Вставить("СвязьУсловий" = СвязьУсловий);
	Возврат ОтборЗапроса;
КонецФункции 

Функция ЗначенияСвязейУсловий()
	Возврат А1Э_Массивы.Создать("И", "ИЛИ");	
КонецФункции

Функция НовыйСравнение(Лево, Право, Компаратор = "=", Параметр = Неопределено) Экспорт
	СравнениеЗапроса = А1Э_Классы.НовыйСравнениеЗапроса();
	СравнениеЗапроса.Лево = Лево;
	СравнениеЗапроса.Компаратор = Компаратор;
	СравнениеЗапроса.Право = Право;
	Возврат СравнениеЗапроса;
КонецФункции

Функция НовыйСравнениеСправаСтрока(Лево, Право, Компаратор = "=", Параметр = Неопределено) Экспорт
	СравнениеЗапроса = НовыйСравнение(Лево, Право, Компаратор, Параметр);
	СравнениеЗапроса.СправаСтрока = Истина;
	Возврат СравнениеЗапроса;
КонецФункции 

#КонецОбласти 

#Область Компоновка 

Функция ДобавитьПоле(СтруктураЗапроса, Имя, Текст = "", Группировка = "") Экспорт
	ДобавитьПоля(СтруктураЗапроса, НовыйПолеЗапроса(Имя, Текст, Группировка));	
КонецФункции

Функция ДобавитьПоля(СтруктураЗапроса, Поля) Экспорт
	Если ТипЗнч(Поля) = Тип("Строка") Тогда
		МассивПолей = А1Э_Строки.Разделить(Поля,",");
	ИначеЕсли ТипЗнч(Поля) = Тип("Массив") Тогда
		МассивПолей = Поля;
	ИначеЕсли А1Э_Структуры.Класс(Поля) = А1Э_Классы.ПолеЗапроса() Тогда
		МассивПолей = А1Э_Массивы.Создать(Поля);
	Иначе
		А1Э_Служебный.ИсключениеНеверныйТип("Поля", "А1Э_Запросы.ДобавитьПоля()", Поля, "Строка, Массив");
	КонецЕсли;
	
	ИмяИсточникаДанных = А1Э_Структуры.ЗначениеСвойства(А1Э_Массивы.Получить(СтруктураЗапроса.ИсточникиДанных, 0), "Имя");
	Для Каждого Поле Из МассивПолей Цикл
		Если ТипЗнч(Поле) = Тип("Строка") Тогда
			Если ИмяИсточникаДанных = Неопределено Тогда
				А1Э_Служебный.СлужебноеИсключение("Для добавления полей по умолчанию в структуре запроса должен быть определен источник данных!");
			КонецЕсли;
			СтруктураЗапроса.Поля.Добавить(НовыйПолеЗапроса(Поле, ИмяИсточникаДанных + "." + Поле));
		ИначеЕсли А1Э_Структуры.Класс(Поле) = А1Э_Классы.ПолеЗапроса() Тогда
			Если Поле.Текст = "" Тогда
				Если ИмяИсточникаДанных = Неопределено Тогда
					А1Э_Служебный.СлужебноеИсключение("Для добавления полей по умолчанию в структуре запроса должен быть определен источник данных!");
				КонецЕсли;
				Поле.Текст = ИмяИсточникаДанных + "." + Поле.Имя;
			КонецЕсли;
			СтруктураЗапроса.Поля.Добавить(Поле);
		Иначе
			А1Э_Служебный.СлужебноеИсключение("Неверный тип в массиве!");
		КонецЕсли;
	КонецЦикла
КонецФункции

Функция ДобавитьИсточникДанных(СтруктураЗапроса, ИсточникДанных, Имя = "") Экспорт  
	Если А1Э_Классы.Класс(ИсточникДанных) = А1Э_Классы.ИсточникДанныхЗапроса() Тогда
		СтруктураЗапроса.ИсточникиДанных.Добавить(ИсточникДанных);
	ИначеЕсли ТипЗнч(ИсточникДанных) = Тип("Строка") Тогда
		Если Имя = "" Тогда
			ВызватьИсключение "При добавлении источника данных обязательно указание имени!";
		КонецЕсли;
		СтруктураЗапроса.ИсточникиДанных.Добавить(НовыйИсточникДанныхЗапроса(Имя, ИсточникДанных));
	КонецЕсли;
КонецФункции

Функция ДобавитьСоединение(ИсточникДанных, Соединение) Экспорт
	ИсточникДанных.Соединения.Добавить(Соединение);
КонецФункции

Функция ДобавитьУсловие(СтруктураЗапросаИлиОтбор, Лево, Право, Компаратор = "", Параметр = Неопределено) Экспорт
	Если А1Э_Классы.Класс(СтруктураЗапросаИлиОтбор) = А1Э_Классы.СтруктураЗапроса() Тогда
		Отбор = СтруктураЗапросаИлиОтбор.Отбор;
	Иначе
		Отбор = СтруктураЗапросаИлиОтбор;
	КонецЕсли;
	Отбор.Сравнения.Добавить(НовыйСравнение(Лево, Право, Компаратор, Параметр));
КонецФункции

#КонецОбласти

#Область Служебно

Функция ОбрезатьЗапятую(МассивСтрок)
	Индекс = МассивСтрок.Количество() - 1;
	Если Индекс < 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	МассивСтрок[Индекс] = А1Э_Строки.Перед(МассивСтрок[Индекс], ",");
КонецФункции

#КонецОбласти

Функция ЗапросИзСтруктуры(СтруктураЗапроса) Экспорт
	Запрос = Запрос(ТекстЗапросаИзСтруктуры(СтруктураЗапроса), ПараметрыЗапросаИзСтруктуры(СтруктураЗапроса));
КонецФункции

Функция ТекстЗапросаИзСтруктуры(СтруктураЗапроса) Экспорт
	Если А1Э_Структуры.Класс(СтруктураЗапроса) <> А1Э_Классы.СтруктураЗапроса() Тогда
		А1Э_Служебный.ИсключениеНеверныйКласс("СтруктураЗапроса", "А1Э_Запросы.ТекстЗапросаИзСтруктуры()", СтруктураЗапроса, А1Э_Классы.СтруктураЗапроса());
	КонецЕсли;
	
	Если СтруктураЗапроса.Ключ = "УНИЧТОЖИТЬ" Тогда
		Возврат ТекстЗапросаУничтожения(СтруктураЗапроса);
	КонецЕсли;
	
	МассивСтрок = Новый Массив;
	НужноГруппировать = Ложь;
	МассивГруппировок = Новый Массив; 
	
	МассивСтрок.Добавить(СтруктураЗапроса.Ключ);
	
	Для Каждого Поле Из СтруктураЗапроса.Поля Цикл
		Если Поле.Группировка = "" Или Поле.Группировка = "ВТексте" Тогда
			ТекстПоля = Поле.Текст;
		Иначе
			ТекстПоля = Поле.Группировка + "(" + Поле.Текст + ")";
		КонецЕсли;
		МассивСтрок.Добавить(ТекстПоля + " КАК " + Поле.Имя + ",");
	КонецЦикла;
	ОбрезатьЗапятую(МассивСтрок);
	
	Если СтруктураЗапроса.ИмяВременнойТаблицы <> "" Тогда  
		МассивСтрок.Добавить("ПОМЕСТИТЬ " + СтруктураЗапроса.ИмяВременнойТаблицы);
	КонецЕсли;
	
	МассивСтрок.Добавить("ИЗ");
	//СтруктураЗапроса.Вставить("ИспользованныеИсточники", Новый Массив);
	//ТУДУ - сделать нормальную компоновку плохо соединенных запросов!.
	А1Э_Массивы.Добавить(МассивСтрок, МассивСтрокТекстаИсточниковДанных(СтруктураЗапроса, СтруктураЗапроса.ИсточникиДанных[0]));
	
	Если СтруктураЗапроса.Отбор.Сравнения.Количество() > 0 Тогда
		МассивСтрок.Добавить("ГДЕ");
		ЭтоПервый = Истина;
		Сч = 1;
		//ТУДУ - сделать компоновку вложенных отборов
		Для Каждого Условие Из СтруктураЗапроса.Отбор.Сравнения Цикл
			Если ЭтоПервый Тогда
				ЭтоПервый = Ложь;
				Разделитель = "";
			Иначе
				Разделитель = СтруктураЗапроса.Отбор.СвязьУсловий + " ";
			КонецЕсли;
			Если ТипЗнч(Условие.Лево) = Тип("Строка") И Условие.СтрокаСлева = Ложь Тогда
				Лево = Условие.Лево;
			Иначе
				Лево = "&А1_Параметр" + Сч;
				Сч = Сч + 1;
			КонецЕсли;
			Если ТипЗнч(Условие.Право) = Тип("Строка") И Условие.СтрокаСправа = Ложь Тогда
				Право = "&А1_Параметр" + Сч;
				Сч = Сч + 1;
			Иначе
				Право = Условие.Право;
			КонецЕсли;
    		МассивСтрок.Добавить(Разделитель + Лево + " " + Условие.Компаратор + " " + Право);
		КонецЦикла;
	КонецЕсли;
	
	НадоГруппировать = Ложь;
	Для Каждого Поле Из СтруктураЗапроса.Поля Цикл
		Если Поле.Группировка <> "" Тогда
			НадоГруппировать = Истина;
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	Если НадоГруппировать Тогда
		МассивСтрок.Добавить("СГРУППИРОВАТЬ ПО");
		Для Каждого Поле Из СтруктураЗапроса.Поля Цикл
			Если Поле.Группировка = "" Тогда
				МассивСтрок.Добавить(Поле.Текст + ",");
			КонецЕсли;
		КонецЦикла;
		ОбрезатьЗапятую(МассивСтрок);
	КонецЕсли;
	
	Возврат СтрСоединить(МассивСтрок, Символы.ПС);
КонецФункции

Функция ПараметрыЗапросаИзСтруктуры(СтруктураЗапроса) Экспорт
	ПараметрыЗапроса = Новый Структура;
	Сч = 1;
	Для Каждого Условие Из СтруктураЗапроса.Отбор.Сравнения Цикл
		Если ТипЗнч(Условие.Лево) <> Тип("Строка") Тогда
			ПараметрыЗапроса.Вставить("А1_Параметр" + Сч, Условие.Лево);
			Сч = Сч + 1;
		КонецЕсли;
		Если ТипЗнч(Условие.Право) <> Тип("Строка") Тогда
			ПараметрыЗапроса.Вставить("А1_Параметр" + Сч, Условие.Право);
			Сч = Сч + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат ПараметрыЗапроса;
КонецФункции

Функция МассивСтрокТекстаИсточниковДанных(СтруктураЗапроса, ИсточникДанных)
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ИсточникДанных.ИсточникДанных + " КАК " + ИсточникДанных.Имя);
	Для Каждого Соединение Из ИсточникДанных.Соединения Цикл
		МассивСтрок.Добавить(Соединение.Тип + " СОЕДИНЕНИЕ");
		А1Э_Массивы.Добавить(МассивСтрок, МассивСтрокТекстаИсточниковДанных(СтруктураЗапроса, 
		А1Э_ТаблицыЗначений.НайтиСтроки(СтруктураЗапроса.ИсточникиДанных, Новый Структура("Имя", Соединение.ИсточникДанных))[0]));
		МассивСтрок.Добавить("ПО");
		МассивСтрок.Добавить(Соединение.Условие);
	КонецЦикла;
	Возврат МассивСтрок;	
КонецФункции

Функция ТекстЗапросаУничтожения(СтруктураЗапроса)
	Возврат "УНИЧТОЖИТЬ " + СтруктураЗапроса.ИмяВременнойТаблицы;
КонецФункции

#КонецОбласти

#Область СегментыЗапросов

Функция УникальноеЗначение(Значение) Экспорт
	Текст = 
	"ВЫБОР
	|	КОГДА МАКСИМУМ(ЕСТЬNULL(&Значение, НЕОПРЕДЕЛЕНО)) = МИНИМУМ(ЕСТЬNULL(&Значение, НЕОПРЕДЕЛЕНО))
	|		ТОГДА МАКСИМУМ(ЕСТЬNULL(&Значение, НЕОПРЕДЕЛЕНО))
	|	ИНАЧЕ ""%НЕУНИКАЛЬНОЕЗНАЧЕНИЕ%""
	|КОНЕЦ";	
	Текст = СтрЗаменить(Текст, "&Значение", Значение);
	Возврат Текст;
КонецФункции 

Функция ИмяТаблицы(Значение) Экспорт
	Возврат Метаданные.НайтиПоТипу(ТипЗнч(Значение)).ПолноеИмя();	
КонецФункции

#КонецОбласти

#Область Трансформации

Функция ЖСОН(Запрос, ЗаписьЖСОН = Неопределено) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		Запрос = Новый Запрос;		
	#КонецЕсли 
	Таблица = Запрос.Выполнить().Выгрузить();
	МассивСтруктур = А1Э_ТаблицыЗначений.ВМассивСтруктур(Таблица);
	Возврат А1Э_Сериализация.ЖСОН(МассивСтруктур, ЗаписьЖСОН);
КонецФункции 

Функция ИерархическийМассивСтруктур(ДанныеДляЗапроса, КолонкиИерархии = Неопределено) Экспорт 
	Значение = Новый Массив;
	Запрос = Запрос(ДанныеДляЗапроса);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Колонки.Найти("ПодчиненныеЭлементы") <> Неопределено Тогда
		А1Э_Служебный.СлужебноеИсключение("Создание иерархического массива структур невозможно для запроса с колонкой <ПодчиненныеЭлементы>!");
	КонецЕсли;
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("КолонкиИерархии", А1Э_Массивы.Массив(КолонкиИерархии));
	ДополнительныеПараметры.Вставить("КолонкиЗапроса", РезультатЗапроса.Колонки);
	
	РекурсивноДобавитьРезультатыЗапросаВМассивСтруктур(Значение, РезультатЗапроса, 0, ДополнительныеПараметры);
	
	Возврат Значение;
КонецФункции

Функция РекурсивноДобавитьРезультатыЗапросаВМассивСтруктур(Значение, ВерхняяВыборка, ТекущаяИерархия, ДополнительныеПараметры) 
	
	Если ДополнительныеПараметры.КолонкиИерархии.Количество() <= ТекущаяИерархия Тогда
		Выборка = ВерхняяВыборка.Выбрать();
		Пока Выборка.Следующий() Цикл
			Структура = Новый Структура;
			Для Каждого Колонка Из ДополнительныеПараметры.КолонкиЗапроса Цикл
				Структура.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);	
			КонецЦикла;
			Значение.Добавить(Структура);
		КонецЦикла;
	Иначе
		Выборка = ВерхняяВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ДополнительныеПараметры.КолонкиИерархии[ТекущаяИерархия]);
		Пока Выборка.Следующий() Цикл
			Структура = Новый Структура;
			Для Каждого Колонка Из ДополнительныеПараметры.КолонкиЗапроса Цикл
				Структура.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
			КонецЦикла;
			Структура.Вставить("ПодчиненныеЭлементы", Новый Массив);
			РекурсивноДобавитьРезультатыЗапросаВМассивСтруктур(Структура.ПодчиненныеЭлементы, Выборка, ТекущаяИерархия + 1, ДополнительныеПараметры); 
			Значение.Добавить(Структура);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Значение;
КонецФункции

#КонецОбласти

#Область Служебно

Функция ПросмотретьВТ(ЗапросИлиМенеджерТаблиц) Экспорт
	#Если Сервер И НЕ Сервер Тогда
		Запрос = Новый Запрос;		
	#КонецЕсли
	
	Если ТипЗнч(ЗапросИлиМенеджерТаблиц) = Тип("МенеджерВременныхТаблиц") Тогда
		РабочийМенеджерВТ = ЗапросИлиМенеджерТаблиц;
	Иначе
		Запрос = ЗапросИлиМенеджерТаблиц;
		Если Запрос.МенеджерВременныхТаблиц = Неопределено Или Запрос.МенеджерВременныхТаблиц.Таблицы.Количество() = 0 Тогда
			РабочийЗапрос = СкопироватьЗапросБезВТ(Запрос);
			РабочийЗапрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			РабочийЗапрос.Выполнить();
		Иначе
			РабочийЗапрос = Запрос;
		КонецЕсли;
		РабочийМенеджерВТ = РабочийЗапрос.МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Структура = Новый Структура;
	Для Каждого Таблица Из РабочийМенеджерВТ.Таблицы Цикл
		Структура.Вставить(Таблица.ПолноеИмя, Таблица.ПолучитьДанные().Выгрузить());
	КонецЦикла;
	
	Возврат Структура;
КонецФункции

Функция СкопироватьЗапросБезВТ(Запрос) 
	НовыйЗапрос = Новый Запрос;
	НовыйЗапрос.Текст = Запрос.Текст;
	Для Каждого Пара Из Запрос.Параметры Цикл
		НовыйЗапрос.УстановитьПараметр(Пара.Ключ, Пара.Значение);
	КонецЦикла;
	Возврат НовыйЗапрос;
КонецФункции

Функция ПодставитьПараметрыВЗапрос(Запрос, Параметры = Неопределено) Экспорт
	Перем МенеджерТаблиц;
	Если Параметры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	А1Э_Структуры.СкопироватьСвойства(Запрос.Параметры, Параметры);
	Если Параметры.Свойство("МенеджерВременныхТаблиц", МенеджерТаблиц) И ТипЗнч(МенеджерТаблиц) = Тип("МенеджерВременныхТаблиц") Тогда
		Запрос.МенеджерВременныхТаблиц = МенеджерТаблиц;
	КонецЕсли;
КонецФункции

Функция РазделительЗапроса()
	Возврат Символы.ПС + ";" + Символы.ПС + Символы.ПС + 
	"////////////////////////////////////////////////////////////////////////////////"
	+ Символы.ПС;
КонецФункции 

// Удаляет операторы УНИЧТОЖИТЬ из текста запроса. Предназначена для использования в процессе отладки.
//
// Параметры:
//  Запрос	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция УбратьУничтожить(Запрос) Экспорт
	ТекстЗапроса = Запрос.Текст;
	Пока Истина Цикл
		Начало = СтрНайти(ТекстЗапроса, "УНИЧТОЖИТЬ");
		Если Начало = 0 Тогда Прервать; КонецЕсли;
		Конец = СтрНайти(ТекстЗапроса, ";", , Начало);
		ТекстЗапроса = Лев(ТекстЗапроса, Начало - 1) + Сред(ТекстЗапроса, Конец + 1);
	КонецЦикла;
	Запрос.Текст = ТекстЗапроса;
КонецФункции

#КонецОбласти 

#Область СКД

// Подставляет в запрос начало и конец периода из параметра вида СтандартныйПериод компоновщика настроек СКД.
//
// Параметры:
//  Запрос				 - Запрос - 
//  КомпоновщикНастроек	 - КомпоновщикНастроекКомпоновкиДанных	 - 
//  Настройки			 - Структура<"НачалоПериода":Строка,"ОкончаниеПериода":Строка,"Период":Строка,"ЗаполнятьПустойПериод":Булево>,Неопределено -
//		"НачалоПериода" и "ОкончаниеПериода" - имена параметров запроса (по умолчанию "НачалоПериода" и "ОкончаниеПериода")
//		"Период" - имя параметра СКД вида СтандартныйПериод (по умолчанию "Период")
//		"ЗаполнятьПустойПериод" - указывает, надо ли подставлять значения в запрос если они не заполнены в СКД (по умолчанию Истина).
//			При заполнении по пустому периоду НачалоПериода = Дата(1,1,1), ОкончаниеПериода = КонецГода(ТекущаяДата()).
// 
// Возвращаемое значение:
//   - 
//
Функция ЗаполнитьПериодПоКомпоновщику(Запрос, КомпоновщикНастроек, Настройки = Неопределено) Экспорт
	ПараметрыПериода = ПараметрыПериодаПоКомпоновщику(КомпоновщикНастроек, Настройки);
	ПодставитьПараметрыВЗапрос(Запрос, ПараметрыПериода);
КонецФункции 

Функция ПараметрыПериодаПоКомпоновщику(КомпоновщикНастроек, Настройки = Неопределено) Экспорт
	ИмяНачалоПериода = А1Э_Структуры.ЗначениеСвойства(Настройки, "НачалоПериода", "НачалоПериода");
	ИмяОкончаниеПериода = А1Э_Структуры.ЗначениеСвойства(Настройки, "ОкончаниеПериода", "ОкончаниеПериода");
	ИмяПериода = А1Э_Структуры.ЗначениеСвойства(Настройки, "Период", "Период");
	ЗаполнятьПустойПериод = А1Э_Структуры.ЗначениеСвойства(Настройки, "ЗаполнятьПустойПериод", Истина);
	
	Период = А1Э_СКД.ЗначениеПараметраДанных(КомпоновщикНастроек, ИмяПериода);
	Результат = Новый Структура;
	Если Период <> Неопределено Тогда
		Результат.Вставить(ИмяНачалоПериода, Период.ДатаНачала);
		Результат.Вставить(ИмяОкончаниеПериода, Период.ДатаОкончания);
		Возврат Результат;	
	КонецЕсли;
	Результат.Вставить(ИмяНачалоПериода, Дата(1,1,1));
	Если ЗаполнятьПустойПериод = Истина Тогда
		ОкончаниеПериода = КонецГода(ТекущаяДата());
	Иначе
		ОкончаниеПериода = Дата(1,1,1);
	КонецЕсли;
	Результат.Вставить(ИмяОкончаниеПериода, ОкончаниеПериода);
	Возврат Результат;
КонецФункции 

#КонецОбласти

#Область ГотовыеТекстыЗапросов

Функция ТекстЗапросаНатуральныйРяд(МаксимальноеЧисло) Экспорт 
	МассивЧастейЗапроса = Новый Массив;
	МассивЧастейЗапроса.Добавить( 
	"ВЫБРАТЬ
	|	0 КАК Число
	|ПОМЕСТИТЬ Числа1
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Большее.Число * 2 + Меньшее.Число КАК Число
	|ПОМЕСТИТЬ Числа2
	|ИЗ
	|	Числа1 КАК Большее,
	|	Числа1 КАК Меньшее
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Большее.Число * 4 + Меньшее.Число КАК Число
	|ПОМЕСТИТЬ Числа3
	|ИЗ
	|	Числа2 КАК Большее,
	|	Числа2 КАК Меньшее");
	ПоследняяТаблица = 3;
	Если МаксимальноеЧисло >= 16 Тогда
		МассивЧастейЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Большее.Число * 16 + Меньшее.Число КАК Число
		|ПОМЕСТИТЬ Числа4
		|ИЗ
		|	Числа3 КАК Большее,
		|	Числа3 КАК Меньшее");
		ПоследняяТаблица = 4;
	КонецЕсли;
	Если МаксимальноеЧисло >= 256 Тогда
		МассивЧастейЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Большее.Число * 256 + Меньшее.Число КАК Число
		|ПОМЕСТИТЬ Числа5
		|ИЗ
		|	Числа4 КАК Большее,
		|	Числа4 КАК Меньшее");
		ПоследняяТаблица = 5;
	КонецЕсли;
	МассивЧастейЗапроса.Добавить(
	Стрзаменить(
	"ВЫБРАТЬ
	|	Числа.Число КАК Число
	|ПОМЕСТИТЬ Числа
	|ИЗ
	|	ПоследняяТаблица КАК Числа
	|ГДЕ
	|	Числа.Число <= &МаксимальноеЧисло", 
	"ПоследняяТаблица", "Числа" + ПоследняяТаблица));
	Возврат А1Э_Запросы.Соединить(МассивЧастейЗапроса);
	
КонецФункции

#КонецОбласти

Функция ИмяМодуля() Экспорт
	Возврат "А1Э_Запросы";	
КонецФункции