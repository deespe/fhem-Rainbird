#####################################################################################
# $Id: 74_RainbirdZone.pm 18798 2019-03-05 19:13:28Z DeeSPe $
#
# Usage
#
# define <name> RainbirdZone <ZONE-NAME>
#
#####################################################################################

package main;

use strict;
use warnings;
use POSIX;
use JSON;
use SetExtensions;
use vars qw{%attr %defs %modules $FW_CSRF};

sub RainbirdZone_Initialize($)
{
  my ($hash) = @_;
  #$hash->{AttrFn}       = "RainbirdZone_Attr";
  $hash->{DefFn}        = "RainbirdZone_Define";
  #$hash->{NotifyFn}     = "RainbirdZone_Notify";
  #$hash->{GetFn}        = "RainbirdZone_Get";
  $hash->{SetFn}        = "RainbirdZone_Set";
  $hash->{UndefFn}      = "RainbirdZone_Undef";
  $hash->{AttrList}     = "$readingFnAttributes";
}

sub RainbirdZone_Define($$)
{
  my ($hash,$def) = @_;
  my @args = split " ",$def;
  my ($name,$type,$zone) = @args;
  if ($init_done && (@args < 3 || @args > 3))
  {
    return "Usage: define <name> RainbirdZone <ZONE-NAME>";
  }
  $hash->{NOTIFYDEV} = "global";
  RemoveInternalTimer($hash);
  if ($init_done && !defined $hash->{OLDDEF})
  {
    addToDevAttrList($name,"homebridgeMapping:textField-long") if (!grep /^homebridgeMapping/,split(" ",$attr{"global"}{userattr}));
    $attr{$name}{alias}         = $zone;
    $attr{$name}{icon}          = "sani_irrigation";
    $attr{$name}{room}          = "Irrigation";
    readingsSingleUpdate($hash,"state","initialized",0);
  }
  return;
}

sub RainbirdZone_Undef($$)
{
  my ($hash,$arg) = @_;
  RemoveInternalTimer($hash);
  return;
}

sub RainbirdZone_Set($@)
{
  my ($hash,$name,@aa) = @_;
  my ($cmd,@args) = @aa;
  return if (IsDisabled($name) && $cmd ne "?");
  return "\"set $name\" needs at least one argument and maximum three arguments" if (@aa > 3);
  my $para = "on:noArg off:noArg toggle:noArg";
  if ($cmd eq "on")
  {
    return undef;
  }
  elsif ($cmd eq "off")
  {
    return undef;
  }
  $hash->{InSetExtensions} = 1;
  my $ret = SetExtensions($hash,$para,$name,@aa);
  delete $hash->{InSetExtensions};
  return $ret;
}

1;

=pod
=item device
=item summary    control Rain Bird LNK equipped devices
=item summary_DE Steuerung von Rain Bird LNK ausgestatteten Ger&auml;ten
=begin html

<a name="Rainbird"></a>
<h3>Rainbird</h3>
<ul>
  With <i>Rainbird</i> you are able to control Rain Bird LNK equipped devices.<br>
  <br>
  <a name="RainbirdZone_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; Rainbird &lt;ZONE-NAME&gt;</code><br>
  </ul>
  <br>
  Example for Rain Bird Zone:
  <br><br>
  <ul>
    <code>define Lawn_left RainbirdZone Lawn_left</code><br>
  </ul>
  <br><br>
  If you have homebridgeMapping in your attributes an appropriate mapping will be added, genericDeviceType as well.
  <br>
  <a name="RainbirdZone_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>on</i><br>
      start irrigation
    </li>
    <li>
      <i>off</i><br>
      stop irrigation
    </li>
    <li>
      <i>toggle</i><br>
      toggle irrigation
    </li>
  </ul>  
  <br>
  <a name="RainbirdZone_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      get status update
    </li>
  </ul>
  <br>
  <a name="RainbirdZone_attr"></a>
  <p><b>Attributes</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      stop polling and disable device completely<br>
      default: 0
    </li>
  </ul>
  <br>
  <a name="RainbirdZone_read"></a>
  <p><b>Readings</b></p>
  <p>All readings updates will create events.</p>
  <ul>
    <li>
      <i>state</i><br>
      current state
    </li>
  </ul>
</ul>

=end html
=begin html_DE

<a name="Rainbird"></a>
<h3>Rainbird</h3>
<ul>
  Mit <i>RainbirdZone</i> k&ouml;nnen Rain Bird Zonen gesteuert werden.<br>
  <br>
  <a name="RainbirdZone_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; Rainbird &lt;ZONE-NAME&gt;</code><br>
  </ul>
  <br>
  Beispiel f&uuml;r:
  <br><br>
  <ul>
    <code>define Lawn_left Rainbird Lawn_left</code><br>
  </ul>
  <br><br>
  Wenn homebridgeMapping in der Attributliste ist, so wird ein entsprechendes Mapping hinzugef&uuml;gt, ebenso genericDeviceType.
  <br>
  <a name="RainbirdZone_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>on</i><br>
      Beregnung starten
    </li>
    <li>
      <i>off</i><br>
      Beregnung stoppen
    </li>
    <li>
      <i>toggle</i><br>
      Beregnung togglen
    </li>
  </ul>  
  <br>
  <a name="RainbirdZone_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      Status Update abrufen
    </li>
  </ul>
  <br>
  <a name="RainbirdZone_attr"></a>
  <p><b>Attribute</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      Anhalten der automatischen Abfrage und komplett deaktivieren<br>
      Voreinstellung: 0
    </li>
  </ul>
  <br>
  <a name="RainbirdZone_read"></a>
  <p><b>Readings</b></p>
  <p>Alle Aktualisierungen der Readings erzeugen Events.</p>
  <ul>
    <li>
      <i>state</i><br>
      aktueller Zustand
    </li>
  </ul>
</ul>

=end html_DE
=cut
