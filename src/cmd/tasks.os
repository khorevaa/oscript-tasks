//    Copyright 2018 khorevaa
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

#Использовать cli
#Использовать tempfiles
#Использовать "."
#Использовать "../core"

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Приложение = Новый КонсольноеПриложение("tasks",
											"Приложение для запуска заданий на OScript");
	Приложение.Версия("version", ПараметрыПриложения.Версия());

	Приложение.Опция("v verbose", Ложь, "вывод отладочной информация в процессе выполнении")
					.Флаговый()
					.ВОкружении("TASKS_VERBOSE");

	Приложение.Опция("f tasks-file", "", "файл с настройкой заданий");
	Приложение.Опция("W workspace", ТекущийКаталог(), "путь к каталогу рабочей области");
	Приложение.Опция("D work-dir", ТекущийКаталог(), "путь к рабочему каталогу");
	Приложение.Опция("s save", Ложь, "признак необходимости сохранить задачу");
	Приложение.Опция("g group", Ложь, "это группа задач");
	Приложение.Опция("l label", "", "наименование задачи при сохранении");
	Приложение.Опция("redirect-out", Неопределено, "перехват потоков вывода и вывода задачи").ТБулево();
	Приложение.Опция("t type", "process", "тип запуска задачи")
					.ТПеречисление()
					.Перечисление("process", "process", "задача будет запускаться как отдельный процесс")
					.Перечисление("internal", "internal", "задача будет запускаться как загрузка скрипта в приложение tasks")
					.Перечисление("cmd", "cmd", "задача будет запускаться c помощью отдельного cmd/shell")
					;
	
	Приложение.Опция("o option", "", "массив опций в виде ключ=значение").ТМассивСтрок();
	Приложение.Опция("e env", "", "массив переменных окружения в виде ключ=значение").ТМассивСтрок();
	
	Приложение.Аргумент("TASK", "", "имя задачи для выполнения");
	Приложение.Аргумент("ARGS", "", "аргументы для выполнения задачи")
						.ТМассивСтрок()
						.Обязательный(Ложь);

	// Приложение.ДобавитьКоманду("group", "Управление группами задач",
	// 							Новый КомандаGroup);
	// Приложение.ДобавитьКоманду("agent a", "Выполняет запуск в режиме агента обновления",
	// 							Новый КомандаAgent);
	// Приложение.ДобавитьКоманду("worker w", "Выполняет запуск рабочего процесса агента",
	// 							Новый КомандаWorker);
	Приложение.УстановитьОсновноеДействие(ЭтотОбъект);
	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры // ВыполнениеКоманды()

Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
	
	ИмяЗадачи			= КомандаПриложения.ЗначениеАргумента("TASK");
	АргументыЗадачи		= КомандаПриложения.ЗначениеАргумента("ARGS");
	ОпцииЗадачи			= ПреобразоватьМассивВСоответствие(КомандаПриложения.ЗначениеОпции("option"));
	ПеременныеОкружения	= ПреобразоватьМассивВСоответствие(КомандаПриложения.ЗначениеОпции("env"));
	ТипЗадачи			= КомандаПриложения.ЗначениеОпции("type");
	
	ФайлНастройкиЗадач 	= КомандаПриложения.ЗначениеОпции("tasks-file");
	
	РабочийКаталог 		= КомандаПриложения.ЗначениеОпции("work-dir");
	РабочаяОбласть		= КомандаПриложения.ЗначениеОпции("workspace");

	ЭтоСохранениеЗадачи = КомандаПриложения.ЗначениеОпции("save");
	ЭтоГруппаЗадач 		= КомандаПриложения.ЗначениеОпции("group");
	НаименованиеЗадачи	= КомандаПриложения.ЗначениеОпции("label");
	ПерехватыватьПотоки	= КомандаПриложения.ЗначениеОпции("redirect-out");

	
	
	МенеджерЗадач = Новый МенеджерЗадач;
	МенеджерЗадач.Настроить(РабочаяОбласть, РабочийКаталог, ФайлНастройкиЗадач);
	
	Если ЭтоСохранениеЗадачи Тогда
		МенеджерЗадач.СохранитьЗадачу(ИмяЗадачи, НаименованиеЗадачи, ЭтоГруппаЗадач, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения, ПерехватыватьПотоки);
	Иначе
		МенеджерЗадач.ВыполнитьЗадачу(ИмяЗадачи, ТипЗадачи, АргументыЗадачи, ОпцииЗадачи, ПеременныеОкружения, ПерехватыватьПотоки);
	КонецЕсли;

КонецПроцедуры

Функция ПреобразоватьМассивВСоответствие(МассивПар)

	Соответствие = Новый Соответствие();

	Для каждого СтрокаМассива Из МассивПар Цикл
		
		МассивКлюча = СтрРазделить(СтрокаМассива, "=");

		Соответствие.Вставить(МассивКлюча[0], МассивКлюча[1]);

	КонецЦикла;
	
	Возврат Соответствие;

КонецФункции


///////////////////////////////////////////////////////

Попытка

	ВыполнитьПриложение();

Исключение
	Сообщить(ОписаниеОшибки());
	ЗавершитьРаботу(1);

КонецПопытки;