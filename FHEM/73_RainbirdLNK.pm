#####################################################################################
# $Id: 74_RainbirdLNK.pm 18798 2019-03-05 19:13:28Z DeeSPe $
#
# Usage
#
# define <name> RainbirdLNK <IP> <PASSWORD> [<INTERVAL>]
#
#####################################################################################

package main;

use strict;
use warnings;
use POSIX;
use Time::HiRes qw(gettimeofday);
#use HttpUtils;
use DevIo;
use JSON;
use Blocking;
use vars qw{%attr %defs %modules $FW_CSRF};

my $version = "0.1.0";

sub RainbirdLNK_Initialize($)
{
  my ($hash) = @_;
  #$hash->{AttrFn}       = "RainbirdLNK_Attr";
  $hash->{DefFn}        = "RainbirdLNK_Define";
  #$hash->{NotifyFn}     = "RainbirdLNK_Notify";
  $hash->{GetFn}        = "RainbirdLNK_Get";
  $hash->{SetFn}        = "RainbirdLNK_Set";
  $hash->{UndefFn}      = "RainbirdLNK_Undef";
  $hash->{AttrList}     = "disable:1,0 ".
                          "disabledForIntervals ".
                          "interval ".
                          $readingFnAttributes;
}

sub RainbirdLNK_Define($$)
{
  my ($hash,$def) = @_;
  my @args = split " ",$def;
  my ($name,$type,$host,$sec,$int) = @args;
  my $port = 80;
  return "Usage: define <name> RainbirdLNK <IP> <PASSWORD> [<INTERVAL>]" if ($init_done && (@args < 4 || @args > 5));
  return "\"$host\" is not a valid IPv4 address" if ($host !~ /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/);
  $int = $int && $int >= 60 ? $int : 60;
  $hash->{DEF}        = $host;
  $hash->{IP}         = $host;
  $hash->{PORT}       = $port;
  $hash->{VERSION}    = $version;
  $hash->{NOTIFYDEV}  = "global";
  $hash->{DeviceName} = "$host:$port";
  RemoveInternalTimer($hash);
  if ($init_done && !defined $hash->{OLDDEF})
  {
    $attr{$name}{alias}     = "Rain Bird LNK Wifi";
    $attr{$name}{icon}      = "it_wifi";
    $attr{$name}{room}      = "Rainbird";
    $attr{$name}{interval}  = $int;
    readingsSingleUpdate($hash,"state","initialized",0);
  }
  return;
}

sub RainbirdLNK_Undef($$)
{
  my ($hash,$arg) = @_;
  RemoveInternalTimer($hash);
  BlockingKill($hash->{helper}{RUNNING_PID}) if ($hash->{helper}{RUNNING_PID});
  DevIo_CloseDev($hash);
  return;
}

sub RainbirdLNK_Set($@)
{
  my ($hash,$name,@aa) = @_;
  my ($cmd,@args) = @aa;
  return if (IsDisabled($name) && $cmd ne "?");
  return "\"set $name $cmd\" needs two arguments at maximum" if (@aa > 2);
  my $para = "password";
  if ($cmd eq "password")
  {
    return "password change not implemented yet...";
  }
  return $para;
}

sub RainbirdLNK_Get($@)
{
  my ($hash,$name,@aa) = @_;
  my ($cmd,@args) = @aa;
  return if (IsDisabled($name) && $cmd ne "?");
  my $para =  "update:noArg";
  return "get $name needs one parameter: $para" if (!$cmd);
  if ($cmd eq "update")
  {
    return undef;
  }
  else
  {
    return "Unknown argument $cmd for $name, choose one of $para";
  }
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
  <a name="RainbirdLNK_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; RainbirdLNK &lt;IP-ADDRESS&gt; &lt;PASSWORD&gt; [&lt;INTERVAL&gt;]</code><br>
  </ul>
  <br>
  Example for running Rainbird:
  <br><br>
  <ul>
    <code>define rb RainbirdLNK 192.168.2.137 mYs€cR3t</code><br>
  </ul>
  <br><br>
  If you have homebridgeMapping in your attributes an appropriate mapping will be added, genericDeviceType as well.
  <br>
  <a name="RainbirdLNK_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>password</i><br>
      set device password
    </li>
  </ul>  
  <br>
  <a name="RainbirdLNK_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      get status update
    </li>
  </ul>
  <br>
  <a name="RainbirdLNK_attr"></a>
  <p><b>Attributes</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      stop polling and disable device completely<br>
      default: 0
    </li>
  </ul>
  <br>
  <a name="RainbirdLNK_read"></a>
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
  <a name="RainbirdLNK_define"></a>
  <p><b>Define</b></p>
  <ul>
    <code>define &lt;name&gt; RainbirdLNK &lt;IP-ADRESSE&gt; &lt;PASSWORT&gt; [&lt;INTERVAL&gt;]</code><br>
  </ul>
  <br>
  Beispiel f&uuml;r:
  <br><br>
  <ul>
    <code>define rb RainbirdLNK 192.168.2.137 mYs€cR3t</code><br>
  </ul>
  <br><br>
  Wenn homebridgeMapping in der Attributliste ist, so wird ein entsprechendes Mapping hinzugef&uuml;gt, ebenso genericDeviceType.
  <br>
  <a name="RainbirdLNK_set"></a>
  <p><b>Set</b></p>
  <ul>
    <li>
      <i>password</i><br>
      Passwort des Ger&auml;tes setzen
    </li>
  </ul>  
  <br>
  <a name="RainbirdLNK_get"></a>
  <p><b>Get</b></p>
  <ul>
    <li>
      <i>update</i><br>
      Status Update abrufen
    </li>
  </ul>
  <br>
  <a name="RainbirdLNK_attr"></a>
  <p><b>Attribute</b></p>
  <ul>
    <li>
      <i>disable</i><br>
      Anhalten der automatischen Abfrage und komplett deaktivieren<br>
      Voreinstellung: 0
    </li>
  </ul>
  <br>
  <a name="RainbirdLNK_read"></a>
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
