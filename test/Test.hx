package;
import haxe.unit.TestRunner;
class Test
{
    public static function main()
    {
        var r:TestRunner = new TestRunner();
        r.add(new ArrayQueryTest());
        r.run();
    }
}
