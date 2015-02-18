#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);

my $module = Modules->CASTEP;

my $doc = $Documents{"Si.xsd"};

my $energyStep = 1.0;
my $energyCutoff = 120;

my $energyResult = $module->GeometryOptimization->Run($doc, Settings(
	OptimizeCell => "Yes", UseCustomEnergyCutoff => "Yes", EnergyCutoff => "$energyCutoff"));
	
my $previousFreeEnergy = $energyResult->FreeEnergy;

print "$previousFreeEnergy\n";

while (abs($energyStep) > 0.01)
{
	$energyCutoff = $energyCutoff + 30;
	
	my $energyResult = $module->GeometryOptimization->Run($doc, Settings(
	Quality => "Medium", OptimizeCell => "Yes", UseCustomEnergyCutoff => "Yes", EnergyCutoff => "$energyCutoff"));

	my $freeEnergy = $energyResult->FreeEnergy;
	
	$energyStep = $freeEnergy - $previousFreeEnergy;
	
	print "$freeEnergy\n";
	
	print "$energyStep\n";
	
	$previousFreeEnergy = $freeEnergy;
	
}
