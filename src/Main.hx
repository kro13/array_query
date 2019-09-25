package;
import ArrayQuery;
import haxe.macro.Expr;

class Main {

    static function main()
    {
        trace("Haxe is great!");
        var arr:Array<Value> = [{val0:10, val1:1}, {val0:0, val1:1}, {val0:3, val1:1}];

        var a = arr[0];
        var q = {val0: 0, val1: 1};

        var item = ArrayQuery.match(arr, q);

        trace(item);
    }

    static function match():Bool
    {
        return true;
    }
}

typedef Value = {
    val0:Int,
    val1:Int
}

private class MyClass
{
    public var v:Int = 1;

    public function new ()
    {
        v = 1;
    }
}

