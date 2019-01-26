#Использовать json
#Использовать types
#Использовать logos
#Использовать 1commands
#Использовать configor

Перем ИндексЗадач;
Перем ОбщиеНастройки;

Перем ИмяКаталогаЗадач;

//Перем РаботаСФайлами;
Перем РабочийИсполнительЗадач;

Перем ПутьКФайлуЗадач;

Перем РабочийКаталог;
Перем РабочаяОбласть;
Перем Лог;

Процедура ПриСозданииОБъекта()
	ИндексЗадач = Новый Соответствие();
	ИмяКаталогаЗадач = "tasks";
	Лог = Логирование.ПолучитьЛог("oscript.lib.tasks");
	Лог = Логирование.ПолучитьЛог("oscript.lib.configor.constructor");
	Лог.УстановитьУровень(УровниЛога.Отладка);

КонецПроцедуры

Процедура СохранитьЗадачу(Знач ИмяЗадачи, Знач НаименованиеЗадачи, Знач ЭтоГруппаЗадач,
						  Знач ТипЗадачи, Знач АргументыЗадачи,
						  Знач ОпцииЗадачи, Знач ПеременныеОкружения) Экспорт
	
	Если ЭтоГруппаЗадач Тогда
		ДобавитьГрупповуюЗадачу(ИмяЗадачи, НаименованиеЗадачи, ТипЗадачи, АргументыЗадачи);
	ИначеЕсли ЭтоВстроеннаяЗадача(ИмяЗадачи) Тогда
		ДобавитьЗадачу(НаименованиеЗадачи, НаименованиеЗадачи, ИмяЗадачи, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);
	Иначе
		ДобавитьЗадачуOscript(ИмяЗадачи, НаименованиеЗадачи, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);
	КонецЕсли;

	СохранитьИндекс();
	
КонецПроцедуры

Процедура ВыполнитьЗадачу(Знач ИмяЗадачи,
						  Знач ТипЗадачи, Знач АргументыЗадачи,
						  Знач ОпцииЗадачи, Знач ПеременныеОкружения) Экспорт

	Если ЭтоВстроеннаяЗадача(ИмяЗадачи) Тогда

		ДобавитьЗадачу(ИмяЗадачи, ИмяЗадачи, ИмяЗадачи, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);
	
	ИначеЕсли НЕ ЗадачаЕстьВИндексе(ИмяЗадачи) Тогда

		ДобавитьЗадачуOscript(ИмяЗадачи, ИмяЗадачи, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);
	
	КонецЕсли;

	РабочийИсполнительЗадач.Исполнить(ИмяЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);
	
КонецПроцедуры

Процедура Настроить(Знач РабочаяОбластьМенеджера, Знач РРабочийКаталогМенеджера, Знач ПутьКФайлу = Неопределено) Экспорт
	
	РабочаяОбласть = РабочаяОбластьМенеджера;
	РабочийКаталог = РРабочийКаталогМенеджера;

	УстановитьПутьКФайлуЗадач(ПутьКФайлу);

	ПрочитатьФайлЗадач();
	
	ПодготовитьИсполнителяЗадач();

КонецПроцедуры

Процедура УстановитьПутьКФайлуЗадач(Знач ПутьКФайлу)
	
	ПутьКФайлуЗадач = ПутьКФайлу;
	Лог.Отладка("Установлен путь к файлу задач <%1>", ПутьКФайлуЗадач);

	Если НЕ ЗначениеЗаполнено(ПутьКФайлуЗадач) Тогда
		ПутьКФайлуЗадач = ПолучитьПутьКФайлуЗадач();		
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПутьКФайлуЗадач()
	
	Если НЕ ЗначениеЗаполнено(ПутьКФайлуЗадач) Тогда
		ПутьКФайлуЗадач = ОбъединитьПути(РабочаяОбласть, ИмяКаталогаЗадач, "tasks.json");
	КонецЕсли;
	Лог.Отладка("Получен путь к файлу задач <%1>", ПутьКФайлуЗадач);

	Возврат ПутьКФайлуЗадач;

КонецФункции

Функция ЭтоВстроеннаяЗадача(Знач ИмяЗадачи)

	МассивИменЗадач = Новый Массив();
	МассивИменЗадач.Добавить("oscript");
	МассивИменЗадач.Добавить("1bdd");
	МассивИменЗадач.Добавить("opm");
	МассивИменЗадач.Добавить("1testtuuner");

	Найдена = НЕ МассивИменЗадач.Найти(НРег(ИмяЗадачи)) = Неопределено;

	Возврат Найдена;

КонецФункции

Функция НайтиФайлЗадачи(Знач ИмяЗадачи);
	
	ПутьКФайлуЗадачи = ОбъединитьПути(РабочаяОбласть, ИмяКаталогаЗадач, ИмяЗадачи + ".os");
	ФайлЗадачи = Новый Файл(ПутьКФайлуЗадачи);

	Если Не ФайлЗадачи.Существует() Тогда
		ОшибкаВыполненияЗадачи(ИмяЗадачи, "не найден файл задачи");
		Возврат "";
	КонецЕсли;

	Возврат ПутьКФайлуЗадачи;

КонецФункции

Процедура ДобавитьЗадачуOscript(Знач ИмяЗадачи, Знач НаименованиеЗадачи,
								Знач ТипЗадачи, Знач АргументыЗадачи,
								Знач ОпцииЗадачи, Знач ПеременныеОкружения)
	
	ПутьКФайлуЗадачи = НайтиФайлЗадачи(ИмяЗадачи);

	ИсполняемыйФайл = ПолучитьПутьКOScript();

	АргументыЗадачи = КопированиеТипа.Скопировать(АргументыЗадачи, Ложь);
	АргументыЗадачи.Вставить(0, "-encoding=utf-8");
	АргументыЗадачи.Вставить(1, ПутьКФайлуЗадачи);
	
	ДобавитьЗадачу(ИмяЗадачи, НаименованиеЗадачи, ИсполняемыйФайл, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения);

КонецПроцедуры

Функция ПолучитьПутьКOScript()
	
	// TODO: СДелать получения  путь через настройки

	Возврат "oscript";

КонецФункции

Процедура ОшибкаВыполненияЗадачи(ИмяЗадачи, ПричинаОшибки)

	Лог.Предупреждение("Задача <%1> не выполнена. По причине - %2", ИмяЗадачи, ПричинаОшибки);
	
КонецПроцедуры

Процедура ОшибкаДобавленияЗадачи(ИмяЗадачи, ПричинаОшибки)

	Лог.Предупреждение("Задача <%1> не добавлена. По причине - %2", ИмяЗадачи, ПричинаОшибки);
	
КонецПроцедуры

Процедура ПодготовитьИсполнителяЗадач()
	
	РабочийИсполнительЗадач = Новый ИсполнительЗадач;
	РабочийИсполнительЗадач.УстановитьИндексЗадач(ИндексЗадач);
	РабочийИсполнительЗадач.УстановитьРабочийКаталог(РабочийКаталог);
	РабочийИсполнительЗадач.УстановитьРабочуюОбласть(РабочаяОбласть);

	// РабочийИсполнительЗадач.УстановитьГлобальныеНастройки();

КонецПроцедуры

Функция ПолучитьКонструкторПараметров() Экспорт
	
	КонструкторЗадачи = ПолучитьКонструкторПараметровЗадачи();

	КонструкторПараметров = Новый КонструкторПараметров;
	КонструкторПараметров.ПолеСтрока("Версия version", "1.0.0")
				.ПолеОбъект("Windows windows", КонструкторЗадачи, Ложь)
				.ПолеОбъект("Osx osx", КонструкторЗадачи, Ложь)
				.ПолеОбъект("Linux linux", КонструкторЗадачи, Ложь)
				.ПолеМассив("Задачи tasks", КонструкторЗадачи)
		;


	Возврат КонструкторПараметров;

КонецФункции

Функция ПолучитьКонструкторПараметровЗадачи() Экспорт
	
	КонструкторПеременныеОкружения = Новый КонструкторПараметров;
	КонструкторПеременныеОкружения.ПроизвольныеПоля();
	
	КонструкторОпцииКоманды = Новый КонструкторПараметров;
	КонструкторОпцииКоманды.ПроизвольныеПоля();
	КонструкторОпцииКоманды.ПолеСтрока("РабочаяОбласть cwd", "");

	КонструкторПараметров = Новый КонструкторПараметров;
	КонструкторПараметров.ПолеСтрока("Наименование label", "")
		.ПолеСтрока("Тип type", "process") // process, cmd
		.ПолеСтрока("Имя name", "")
		.ПолеСтрока("Команда command", "oscript")
		.ПолеМассив("Аргументы args", Тип("Строка"))
		.ПолеОбъект("ПеременныеОкружения env", КонструкторПеременныеОкружения)
		.ПолеОбъект("Опции options", КонструкторОпцииКоманды)
		.ПолеМассив("ВложенныеЗадачи tasks sub", Тип("Строка"))
		;

	Возврат КонструкторПараметров;

КонецФункции

Процедура ПрочитатьФайлЗадач() Экспорт
	
	НастройкаИзФайла = ПрочитатьФайлНастройкиЗадач(ПутьКФайлуЗадач);

	ОбщиеНастройки = Новый Структура("Версия, Windows, Linux, Osx");
	ОбщиеНастройки.Версия = НастройкаИзФайла.Версия;
	
	Если НастройкаИзФайла.Свойство("Windows") Тогда
		ОбщиеНастройки.Вставить("Windows", НастройкаИзФайла.Windows);
	КонецЕсли;

	Если НастройкаИзФайла.Свойство("Linux") Тогда
		ОбщиеНастройки.Вставить("Linux", НастройкаИзФайла.Windows);
	КонецЕсли;

	Если НастройкаИзФайла.Свойство("Linux") Тогда
		ОбщиеНастройки.Вставить("Linux", НастройкаИзФайла.Linux);
	КонецЕсли;

	НаборЗадач = НастройкаИзФайла.Задачи;

	ЗаполнитьИндекс(ИндексЗадач, НаборЗадач);
	
КонецПроцедуры

Функция ПустаяНастройка()
	
	Конструктор = ПолучитьКонструкторПараметров();

	ПустаяНастройка = Конструктор.ИзСоответствия(Новый Соответствие()).ВСтруктуру();

	Возврат ПустаяНастройка;

КонецФункции

Функция ПрочитатьФайлНастройкиЗадач(Знач ПутьКФайлуЗадач)
	
	ФайлЗадач = Новый Файл(ПутьКФайлуЗадач);

	Если НЕ ФайлЗадач.Существует() Тогда
		Возврат ПустаяНастройка();
	КонецЕсли;
	Лог.Отладка("Читаю файл задач <%1>", ПутьКФайлуЗадач);

	ТекстФайла = РаботаСФайлами.ПрочитатьФайл(ФайлЗадач.ПолноеИмя);

	Лог.Отладка("Текст файл задач <%1>", ТекстФайла);
	ДанныеИндексаИзФайла = РаботаСФайлами.ИзJson(ТекстФайла);

	Конструктор = ПолучитьКонструкторПараметров();

	Конструктор.ИзСоответствия(ДанныеИндексаИзФайла);
	СтруктураИФайла = Конструктор.ВСтруктуру();

	Возврат СтруктураИФайла;

КонецФункции

Процедура ЗаполнитьИндекс(Индекс, НаборЗадач)

	Для каждого Задача Из НаборЗадач Цикл
		ЗадачаИндекса = ДобавитьЗадачуВИндекс(Индекс
							, Задача["Имя"]
							, Задача["Наименование"]
							, Задача["Команда"]
							, Задача["Тип"]
							, Задача["Аргументы"]
							, Задача["Опции"]
							, Задача["ПеременныеОкружения"]
							);
		
		ЗадачаИндекса.ЗаполнитьВложенныеЗадачи(Задача["ВложенныеЗадачи"]);
		
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьГрупповуюЗадачу(Знач ИмяЗадачи, Знач НаименованиеЗадачи,
								  Знач ТипЗадачи = "process",
								  Знач АргументыЗадачи)

	Если АргументыЗадачи.Количество() = 0  Тогда
		Возврат;
	КонецЕсли;

	Задача = ДобавитьЗадачуВИндекс(ИндексЗадач, ИмяЗадачи, НаименованиеЗадачи, "", ТипЗадачи);
	Задача.ЗаполнитьВложенныеЗадачи(АргументыЗадачи);
		
КонецПроцедуры

Процедура ДобавитьЗадачу(Знач ИмяЗадачи, Знач НаименованиеЗадачи, Знач Команда, Знач ТипЗадачи = "process",
						 Знач АргументыЗадачи = Неопределено, Знач ОпцииЗадачи = Неопределено,
						 Знач ПеременныеОкруженияЗадачи = Неопределено)

	ДобавитьЗадачуВИндекс(ИндексЗадач, ИмяЗадачи, НаименованиеЗадачи, Команда, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкруженияЗадачи);
	
КонецПроцедуры

Функция ДобавитьЗадачуВИндекс(Знач Индекс, Знач ИмяЗадачи, Знач НаименованиеЗадачи,
								Знач Команда, Знач ТипЗадачи = "process"
								Знач АргументыЗадачи = Неопределено, Знач ОпцииЗадачи = Неопределено,
								Знач ПеременныеОкруженияЗадачи = Неопределено)

	Задача = Новый Задача(ИмяЗадачи, НаименованиеЗадачи, Команда, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкруженияЗадачи);

	Индекс.Вставить(ИмяЗадачи, Задача);

	Возврат Задача;

КонецФункции

Процедура СохранитьИндекс()

	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("version", ОбщиеНастройки.Версия);
	
	Если ОбщиеНастройки.Свойство("Windows") Тогда
		СтруктураОбъекта.Вставить("Windows", ОбщиеНастройки.Windows);
	КонецЕсли;

	Если ОбщиеНастройки.Свойство("Linux") Тогда
		СтруктураОбъекта.Вставить("Linux", ОбщиеНастройки.Windows);
	КонецЕсли;

	Если ОбщиеНастройки.Свойство("Linux") Тогда
		СтруктураОбъекта.Вставить("Linux", ОбщиеНастройки.Linux);
	КонецЕсли;
	
	МассивЗадач = Новый Массив();

	Для каждого ЗадачаИндекса Из ИндексЗадач Цикл
		
		МассивЗадач.Добавить(ЗадачаИндекса.Значение.ОписаниеДляЗаписи());

	КонецЦикла;

	Если МассивЗадач.Количество() > 0  Тогда
		СтруктураОбъекта.Вставить("tasks", МассивЗадач);
	КонецЕсли;

	ТекстJSON = РаботаСФайлами.ВJson(СтруктураОбъекта);

	Лог.Отладка("Путь к файлу задач <%1>", ПутьКФайлуЗадач);

	РаботаСФайлами.ЗаписатьФайл(ПутьКФайлуЗадач, ТекстJSON);
	
КонецПроцедуры

Функция ЗадачаЕстьВИндексе(Знач ИмяЗадачи)
	
	Возврат НЕ ИндексЗадач[ИмяЗадачи] = Неопределено;

КонецФункции