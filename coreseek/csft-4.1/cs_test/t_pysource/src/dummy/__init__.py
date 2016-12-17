# -*- coding: utf-8 -*-

g_cnt = 0

class MainSource(object):
    def __init__(self, conf):
        self.conf =  conf
        self.data = [
            {'id':1, 'Filename':'cm-05 test1', 'context':u'world c++ bbbb aaaaa zzzz hello world . zzzz Test phrase ', 'attr':1, 'tags':[2,4,5]},
            {'id':2, 'Filename':'test2', 'context':'c# asp.net hello .net', 'attr':1, 'tags':[1,2,3]},
            #{'id':3, 'Filename':'test2111', 'context':'world c# zzzz hello golf zzzz wwww', 'attr':3, 'tags':[5,6,7]},
            {'id':4, 'Filename':'test21112', 'context':'中文 分 词算 法 222 我是最好的.', 'attr':3, 'tags':[9,8]},
			#{'id':4, 'Filename':'test21112', 'context':'中文分词算法 222我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错. 今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错.我是最好的.今天天气不错. 测试结尾', 'attr':3, 'tags':[9,8]},
        ]
        self.idx = 0
        self.join_idx = 0
        self.max_iter = 1
        self.docfield_gen = None
        self.docmva = None
        
    def GetScheme(self):
        return [
            ('id' , {'docid':True, } ),
            ('filename', { 'type':'string'} ), #wordpart can be whole, infix, prefix
            ('context', { 'type':'text'} ),
            ('attr', {'type':'integer'} ),
            ('tags', {'type':'list-query'} ),
        ]
       
    def GetKillList(self):
        return [3,1]
    
    def GetFieldOrder(self):
        '''
           - can return a tuple
           - if return two tuple, the first used as traditional field fetch -> attribute;
                                  the second used as sql join like, can fetch context via GetDocField
        '''
        #return [('Filename','context'),]
	return [('context',) , ()]
        #return [('Filename',), ('Filename', 'context'),]
        #return [('Filename',), ('context',),]
    
    def _DocFieldGen(self, fieldname):
        # 1 2 4
		#print self.join_idx , self.max_iter
		while self.join_idx < 1:
			yield {'Filename':(self.join_idx*10 + 1, 'hello world', 20), 'context':(self.join_idx*10 + 1, 'hello cccc')}
			yield {'Filename':(self.join_idx*10 + 2, 'baal6tio12 gave rise to al o hole centres whereas no paramagnetic, centres corresponding to boron could be detected on b2o3 addition. Hello1 world.', 10), 'context':(self.join_idx*10 + 2, 'hello cccc world nz')}
			yield {'Filename':(self.join_idx*10 + 4, 'test', 10), 'context':(self.join_idx*10 + 4, 'hello cccc world nz')}
			self.join_idx  += 1
        #yield (2, 'test', 10)
        #yield (4, '123', 10)
    
    def GetDocField(self, fieldname, hitc):
        '''
            return (docid, context_of_field, [ipos] )
			return {'fieldname':(docid, context_of_field, [ipos] )} #used to return multi-fields. eg. a single joined table with multi field.
        '''
        #print hitc.getFieldName(),'--------------'
        
        if self.docfield_gen == None:
            self.docfield_gen = self._DocFieldGen(fieldname)
        try:
            rs = self.docfield_gen.next()
            #print '====', rs
            return rs
        except StopIteration, e:
            print e
            return None
        pass
    
    def GetMVAValue(self, fieldname, hitc):
        '''
            return (docid, value), return multi time for an attribute of a single document.
			return {'fieldname':(docid, value)} #used to return multi-value.
        '''
        if self.docmva == None:
            self.docmva = 1
            return (1, 3)
        if self.docmva == 1:
            self.docmva = 2
            return (1, 4)
        
    def Connected(self):
        pass
    
    def NextDocument(self, hitc):
        hitc.pushWord('__2_1999', fieldindex = 0)
        if self.idx < len(self.data):
            item = self.data[self.idx]
            self.id = item['id']+self.max_iter*4
            self.Filename = item['Filename']
            self.filename = item['Filename']
            self.context = item['context']
            self.attr = item['attr']
            self.tags = item['tags']
            self.idx += 1
            return True
        else:
            if self.max_iter:
                self.max_iter -= 1
                self.idx = 0
                return self.NextDocument(hitc);
            return False
    
    def BuildHits(self, hitc):
        '''
            If you do NOT wanna to build hit by hand, must return false.
        '''
        global g_cnt
        hitc.pushWord("coreseek", fieldindex = 4)
        #hitc.pushWord(None, 100, 10)
        #return True
        #print hitc.getFieldName()
        return False
        if "context" == hitc.getFieldName():
            ctx = self.context
            toks = ctx.split()
            hitc.pushWord(None, 100, 10)
            for tok in toks:
                g_cnt += 1
                print self.id, g_cnt, ctx
                hitc.pushWord(tok)
                if tok == "222":
                    hitc.pushWord("coreseek", fieldindex = 4)
                    pass
                #print tok
            return True
        return False
        #return False
        #pass
        
