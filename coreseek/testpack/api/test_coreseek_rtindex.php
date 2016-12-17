<?php
// --------------------------------------------------------------------------
// File name   : test_coreseek_rtindex.php
// Description : coreseek中文全文检索系统实时索引测试程序
// Requirement : PHP5 (http://www.php.net)
//
// Copyright(C), HonestQiao, 2011, All Rights Reserved.
//
// Author: HonestQiao (honestqiao@gmail.com)
//
// 最新使用文档，请查看：http://www.coreseek.cn/products/products-install/
//
// --------------------------------------------------------------------------

#连接到实时索引，使用MySQL41协议
$link = mysql_connect('localhost:9306') or die('connect bad');
if (!$link) {
    echo mysql_errno() . ": " . mysql_error(). "\n";
    exit;
}
else
{
    echo "搜索服务：连接成功\n";
}

#查询id为1的文档
$id=1;
$query=mysql_query("SELECT * FROM rtindex WHERE id=$id");
if(mysql_errno())
{
    echo mysql_errno() . ": " . mysql_error(). "\n";
    exit;
}
else
{
    echo "查询数据：查询成功\n";
}

if(mysql_num_rows($query)){
    echo "查询数据：id为 $id 的数据存在\n";
    while($row=mysql_fetch_array($query,MYSQL_ASSOC))
    {
        printf("标题：%s\n",$row['title']);
    }
}
else
{
    echo "新增数据：插入id为 $id 的数据\n";

    $title = '愚人节最佳蛊惑爆料 谷歌300亿美元收购百度';
    $content = '据国外媒体报道，谷歌将巨资收购百度，涉及金额高达300亿美元。谷歌借此重返大陆市场。
　　该报道称，目前谷歌与百度已经达成了收购协议，将择机对外公布。百度的管理层将100%保留，但会将项目缩减，包括有啊商城，以及目前实施不力的凤巢计划。正在进行测试阶段的视频网站qiyi.com将输入更多的Youtube资源。(YouTube在大陆区因内容审查暂不能访问)。
　　该消息似乎得到了谷歌CEO施密特的确认，在其twitter上用简短而暧昧的文字进行了表述：“ Withdraw from that market? u\'ll also see another result, just wait... ” 意思是：从那个市场退出?你还会看到另外一个结果。毫无疑问，那个市场指的就是中国大陆。而另外的结果，对应此媒体报道，就是收购百度，从而曲线返回大陆搜索市场。
　　在最近刚刚结束的深圳IT领袖峰会上，李彦宏曾言，“谷歌没有退出中国，因为还在香港”。也似乎在验证被收购的这一事实。
　　截止发稿，百度的股价为597美元，市值为207亿美元。谷歌以高达300亿美元的价格，实际溢价高达50%。而谷歌市值高达1796亿美元，而且手握大量现金，作这样的决策也在情理之中。
    近日，很多媒体都在报道百度创始人、CEO李彦宏的两次拒购：一次是百度上市前夕，李彦宏拒绝谷歌的并购，这个细节在2月28日央视虎年首期对话节目中得到首次披露﹔一次是在百度国际化战略中，拒绝采用海外并购的方式，而是采取了从日本市场开始的海外自主发展之路。这也让笔者由此开始思考民族品牌的发展之路。
　　收购是打压中国品牌的惯用伎俩
　　2010年2月28日，央视经济频道《对话》节目昨晚推出虎年首期节目，百度董事长兼CEO李彦宏作为嘉宾做客节目。李彦宏首度谈及2005年百度上市前夕，谷歌CEO施密特曾秘密造访百度时秘密谈话的内容，主要是劝阻百度上市，李彦宏断然拒绝了施密特的“好意”。今天看来，施密特当日也许已有不祥的预感，这个几百人的小公司终有一日会成为他们的大麻烦。
　　本期《对话》一经播出，便引发了业界讨论。
　　外资品牌通过收购打压中国品牌的案例不胜枚举。从以往跨国企业并购的中国品牌来看，真正让其活下来的品牌并不多，要么被雪藏，要么被低端化。
　　因此，2005年百度没有接受Google的收购邀请，坚持自主发展，这对于保护中国品牌，维护中国网民信息安全有着至关重要的作用。当前百度市场份额高达76%，并持续增长，这也充分验证了李彦宏拒绝收购决策的正确性。
　　今天看来，“百度一下”已经成为3亿多中国网民的网络生存法则，而直到今天环视全球，真正能像中国一样，拥有自己独立搜索引擎的只有4个国家！我们也许应该庆幸当时李彦宏的选择。这个故事也告诉我们，中国企业做品牌还要靠自己！
　　收购也可能是中国企业走出去的陷阱
　　同样在2月28日，亚布力第十届年会上，李彦宏在论坛上指出：“我们和很多其它公司的国际化路子是很不一样的，我们不是去买一个国外的公司，”，李彦宏解释了百度率先选择日本作为走出去的对象的原因，因为日本和中国一衣带水的近邻优势，日本的市场规模，在日本也没有一家独大的搜索引擎。
　　中国企业收购这些外资品牌目的是“借船出海”。外资品牌进入中国是收购中国优质品牌，而中国企业进入国外市场的收购策略恰恰相反，这也是中国企业借船出海屡屡失败的原因所在。
　　笔者认为，中国互联网公司走出去要依靠自身发展，并不能单纯依靠收购。李彦宏在百度成立伊始就抱定了国际化决心，使百度真正在面对国际化机遇时，更加冷静和具有前瞻力。李彦宏也承认当前百度在日本还处于初级发展阶段，但他也预言“2012年，百度与Google划洋而治”，对此我们拭目以待！';
    $groupid = 1;
    $biguid = '12345678901234';
    $score = 12.34;
    $date_added = time();
    $author = '知名编辑';

    //主键id，需要自己设置，不会自动生成或者递增（AUTO_INCREMENT）
    $content = mysql_escape_string($content);
    mysql_query($sql="INSERT INTO rtindex(id,title,content,groupid,biguid,score,date_added,author) VALUES ( $id, '$title', '$content', $groupid,$biguid,$score,$date_added,'$author')");
    if(mysql_errno())
    {
        echo mysql_errno() . ": " . mysql_error(). "\n";
        echo $sql;
        exit;
    }
    else
    {
        echo "新增数据：插入成功\n";
    }
}

echo "\n全文检索：\n";
$query=mysql_query("SELECT * FROM rtindex WHERE MATCH('网络搜索')");
if(mysql_errno())
{
    echo mysql_errno() . ": " . mysql_error(). "\n";
    exit;
}
else
{
    echo "搜索数据：搜索成功\n";
}
while($row=mysql_fetch_array($query,MYSQL_ASSOC))
{
    print_r($row);
}

echo "搜索数据：状态获取\n";
$query=mysql_query("SHOW META");
if(mysql_errno())
{
    echo mysql_errno() . ": " . mysql_error(). "\n";
    exit;
}
else
{
    echo "搜索数据：状态获取成功\n";
}
while($row=mysql_fetch_array($query,MYSQL_NUM))
{
    printf("%s\t%s\n",$row[0],$row[1]);
}
