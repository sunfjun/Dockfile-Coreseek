#ifndef _PY_LAYER_H_
#define _PY_LAYER_H_
#include "sphinx.h"

#if USE_PYTHON

#if USE_PYTHON_DEBUG	
	#include   <Python.h>    

#else

	#ifdef _DEBUG
		#define D_E_B_U_G
		#undef   _DEBUG
	#endif
	#include   <Python.h>    
	#ifdef	D_E_B_U_G
		#undef  D_E_B_U_G
		#define _DEBUG
	#endif

#endif //USE_PYTHON_DEBUG

//////////////////////////////////////////////////////////////////////////

bool			cftInitialize( const CSphConfigSection & hPython);
void			cftShutdown();

CSphSource * SpawnSourcePython ( const CSphConfigSection & hSource, const char * sSourceName);

typedef struct {
	PyObject_HEAD
		/* Type-specific fields go here. */
		CSphSource* m_pSource;
	CSphSchema* m_tSchema;
	CSphString* m_FieldName;
	int iPos;
	int iPhrase;
	int iField;
} csfHelper_HitCollectorObject;

#endif //USE_PYTHON

#endif

