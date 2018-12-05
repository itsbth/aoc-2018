use v6.c;

my @a = 'input'.IO.slurp.comb>>.ord;
my @o = [0];
for @a -> $c {
  if (@o[* - 1] - $c).abs == 32 {
    @o.pop;
  } else {
    @o.push($c);
  }
}
say @o.elems - 1;
