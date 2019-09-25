package;
import ArrayQuery;
import haxe.macro.Expr;

class Main {

    static function main()
    {
        trace("Haxe is great!");
        var arr:Array<Value> = [{val0:10, val1:1}, {val0:0, val1:1}, {val0:3, val1:1}];

        var a = arr[0];
        var q = {val0: 0, val2: 1};

        //trace(ArrayQuery.match(arr[1], {val0: 10, val1: 1}));
        var item = ArrayQuery.match(arr, q);
        trace(item);
        //ArrayQuery.run(arr, {val0:1});
        //trace(ArrayQuery.match(arr[0], {val0:1}));
        //trace(ArrayQuery.match(arr[0], q));

        /*ArrayQuery.testExpr({val1:1});
        var q:Value = {val0:0, val1:1};
        ArrayQuery.testExpr(q);
        var c:MyClass = new MyClass();
        ArrayQuery.testExpr(c);*/
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

/*
    class Main {

        static function main()
        {
            traceExpr({v:1}); //EObjectDecl([{ expr => { expr => EConst(CInt(1)), pos => #pos(src/Main.hx:42: characters 25-26) }, ??? => #pos(src/Main.hx:42: characters 23-24), field => v }])
            var a = {v:1};
            traceExpr(a); //EConst(CIdent(a))
        }

        public macro static function traceExpr(ex:Expr):Expr
        {
            trace(ex.expr);
            return macro $v{null};
        }

    }*/
