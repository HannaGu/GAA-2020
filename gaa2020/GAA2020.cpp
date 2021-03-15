#include "stdafx.h"
#include "Error.h"
#include "Parm.h"
#include "Log.h"
#include "In.h"
#include "FST.h"
#include "LT.h"
#include "Graphs.h"
#include "LexicalAnalysis.h"
#include "Split.h"
#include "ErrorTest.h"
#include "Polish.h"
#include "MFST.h"
#include "MFST_trace.h"
#include "SemanticAnalysis.h"
#include "CodeGeneration.h"

#define FILE "C:\\Users\\Lenovo PC\\Desktop\\CourseWork\\gaa2020\\ASM\\ASM.asm"

int _tmain(int argc, wchar_t* argv[])
 {
	setlocale(LC_ALL, "ru");
	Log::LOG	log = Log::INITLOG;
	try
	{
		Parm::PARM parm = Parm::getparm(argc, argv);
		log = Log::getlog(parm.log);

		Log::WriteLog(log);
		Log::WriteParm(log, parm);
		In::IN in = In::getin(parm.in);
	    Log:WriteIn(log, in);
		
		Lex::LEX lex = Lex::LexicalAnalysis(log, in);
		Lex::LTLog(lex.lextable, log);
		Lex::ITLog(lex.idtable, log);
		std::cout<<"����������� ������ �������� �������."<<std::endl;

		MFST_TRACE_START
		MFST::Mfst mfst(lex.lextable, GRB::getGreibach());
		mfst.start(log);		
		mfst.savededucation();
		mfst.printrules(log);
		std::cout << "�������������� ������ �������� �������." << std::endl;

		Sem::CheckAssignValue(log, lex.lextable, lex.idtable);
		Sem::CheckAllowedValue(log, lex.lextable, lex.idtable);
		Sem::CheckReturnType(log, lex.lextable, lex.idtable);
		Sem::CheckParm(log, lex.lextable, lex.idtable);
		Sem::CheckFunc(log, lex.lextable, lex.idtable);
		std::cout << "������������� ������ �������� �������." << std::endl;

		CG::ConstSegment CnstS(lex.idtable.size);
		CG::DataSegment Data(lex.idtable.size);
		CG::CodeSegment Code;
		CG::add(lex.idtable, CnstS);
		CG::add(lex.idtable, Data);
		CG::CodeSegmentGeneration(Code, lex.lextable, lex.idtable);
		CG::startGeneration(FILE, CnstS, Data, Code);
		std::cout << "��������� ���� ��������� �������." << std::endl;
		Log::Close(log);
		//system("start \"�:\\Users\\Lenovo PC\\Desktop\\CourseWork\\gaa2020\\compilation.bat\"");
	}
	catch (Error::ERROR e)
	{
		Log::WriteError(log, e);
	}
	system("pause");
	return 0;

}