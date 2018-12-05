use v6.c;

my $polymer = 'input'.IO.slurp;
my @ul = ('A'..'Z').map: { $_ ~ .lc };
my @lu = ('a'..'z').map: { $_ ~ .uc };

my $l = 0;

while ($l ≠ $polymer.chars) {
  say "$l -> $($polymer.chars)";
  $l = $polymer.chars;
  $polymer .=subst(rx/@ul|@lu/, '', :g);
}
say $polymer.chars;
