#####################################################################################
# $Id: 74_Rainbird.pm 18798 2019-03-05 19:13:28Z DeeSPe $
#
# Usage
#
# define <name> Rainbird <IP> <PASSWORD> [<INTERVAL>]
#
#####################################################################################

package main;

use strict;
use warnings;
use POSIX;
use Time::HiRes qw(gettimeofday);
use HttpUtils;
use vars qw{%attr %defs %modules $FW_CSRF};

sub Rainbird_Initialize($)
{
  my ($hash) = @_;
  #$hash->{AttrFn}       = "Rainbird_Attr";
  $hash->{DefFn}        = "Rainbird_Define";
  #$hash->{NotifyFn}     = "Rainbird_Notify";
  #$hash->{GetFn}        = "Rainbird_Get";
  #$hash->{SetFn}        = "Rainbird_Set";
  $hash->{UndefFn}      = "Rainbird_Undef";
  $hash->{AttrList}     = "disable ".
                          "rb_interval ".
                          "rb_test ".
                          "$readingFnAttributes";
}

sub Rainbird_Define($$)
{
  my ($hash,$def) = @_;
  my @args = split " ",$def;
  my ($name,$type,$host,$sec,$int) = @args;
  my $port = 80;
  if (@args < 4 || @args > 5)
  {
    return "Usage: define <name> Rainbird <IP> <PASSWORD> [<INTERVAL>]";
  }
  $int = $int && $int>59?$int:60;
  $hash->{DEF}    = $host;
  $hash->{IP}     = $host;
  $hash->{PORT}   = $port;
  $hash->{NOTIFYDEV} = "global";
  $hash->{DeviceName} = "$host:$port";
  RemoveInternalTimer($hash);
  if ($init_done && !defined $hash->{OLDDEF})
  {
    addToDevAttrList($name,"homebridgeMapping:textField-long") if (!grep /^homebridgeMapping/,split(" ",$attr{"global"}{userattr}));
    $attr{$name}{alias}         = "Rainbird Irrigation";
    $attr{$name}{icon}          = "sani_irrigation";
    $attr{$name}{room}          = "Irrigation";
    $attr{$name}{rb_interval}   = $int;
    readingsSingleUpdate($hash,"state","initialized",0);
  }
  return;
}

sub Rainbird_Undef($$)
{
  my ($hash,$arg) = @_;
  RemoveInternalTimer($hash);
  return;
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
  <a name="Rainbird_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; Rainbird &lt;IP-ADDRESS&gt; &lt;PASSWORD&gt; [&lt;INTERVAL&gt;]</code><br>
  </ul>
  <br>
  Example for running Rainbird:
  <br><br>
  <ul>
    <code>define rb Rainbird 192.168.2.137 mYs€cR3t</code><br>
  </ul>
  <br><br>
  If you have homebridgeMapping in your attributes an appropriate mapping will be added, genericDeviceType as well.
  <br>
  <a name="Rainbird_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>on</i><br>
      start irrigation
    </li>
  </ul>  
  <br>
  <a name="Rainbird_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      get status update
    </li>
  </ul>
  <br>
  <a name="Rainbird_attr"></a>
  <p><b>Attributes</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      stop polling and disable device completely<br>
      default: 0
    </li>
  </ul>
  <br>
  <a name="Rainbird_read"></a>
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
  Mit <i>Rainbird</i> k&ouml;nnen Rain Bird LNK ausgestatteten Ger&auml;te gesteuert werden.<br>
  <br>
  <a name="Rainbird_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; Rainbird &lt;IP-ADRESSE&gt; &lt;PASSWORT&gt; [&lt;INTERVAL&gt;]</code><br>
  </ul>
  <br>
  Beispiel f&uuml;r:
  <br><br>
  <ul>
    <code>define rb Rainbird 192.168.2.137 mYs€cR3t</code><br>
  </ul>
  <br><br>
  Wenn homebridgeMapping in der Attributliste ist, so wird ein entsprechendes Mapping hinzugef&uuml;gt, ebenso genericDeviceType.
  <br>
  <a name="Rainbird_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>on</i><br>
      Beregnung starten
    </li>
  </ul>  
  <br>
  <a name="Rainbird_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      Status Update abrufen
    </li>
  </ul>
  <br>
  <a name="Rainbird_attr"></a>
  <p><b>Attribute</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      Anhalten der automatischen Abfrage und komplett deaktivieren<br>
      Voreinstellung: 0
    </li>
  </ul>
  <br>
  <a name="Rainbird_read"></a>
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
