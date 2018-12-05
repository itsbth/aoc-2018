use v6.c;

my @a = 'input'.IO.slurp.comb>>.ord;
sub solve (@a) {
  my @o = [0];
  for @a {
    if (@o[* - 1] - $_).abs == 32 {
      @o.pop;
    } else {
      @o.push($_);
    }
  }
  return @o.elems - 1;
}
say "Part 1: $(solve(@a))";

for 'A'...'Z' {
  my @m = @a.grep(* ≠ $_.ord).grep(* ≠ $_.lc.ord);
  say "$_: $(solve(@m))";
}
