
Unit dmGEE_SetAllConditionsToEqualOr;


Function Initialize: integer;
Begin
End;

Function Finalize : integer;
Begin
End;


Function Process(e: IInterface): integer;
Begin
  AddMessage('Processing: ' + FullPath(e));
  ProcessPerk(e);
End;

Function ProcessPerk(e: IInterface): integer;
Begin
  If Signature(e) <> 'PERK' Then
    Begin
      AddMessage(FullPath(e) + ' is not a perk!');
      exit;
    End;
  ProcessEffectList(ElementByName(e, 'Effects'));
End;

Function ProcessEffectList(e: IInterface;): integer;

Var i: integer;
Begin
  If ElementCount(e) <= 0 Then
    Begin
      AddMessage(FullPath(e) + ' has no effects!');
      exit;
    End;

  For i := 0 To ElementCount(e) - 1 Do
    Begin
      ProcessEffect(ElementByIndex(e, i))
    End;
End;

Function ProcessEffect(e: IInterface;): integer;
Begin
  ProcessPerkConditionsList(ElementByName(e, 'Perk Conditions'));
End;

Function ProcessPerkConditionsList(e: IInterface; modVal): integer;

Var i: integer;
Begin
  If ElementCount(e) = 0 Then
    Begin
      AddMessage(FullPath(e) + ' does not have any perk conditions!');
      exit;
    End;

  For i := 0 To ElementCount(e) - 1 Do
    ProcessConditionList(ElementByName(ElementByIndex(e, i),'Conditions'));
End;

Function ProcessConditionList(e: IInterface): integer;

Var i: integer;
Begin
  If ElementCount(e) = 0 Then
    Begin
      AddMessage(FullPath(e) + ' does not have any conditions!');
      exit;
    End;

  For i := 0 To ElementCount(e) - 1 Do
    ProcessCondition(ElementByIndex(e, i));
End;

Function ProcessCondition(e: IInterface): integer;
Begin
  SetElementEditValues(e, 'CTDA - CTDA\Type', '10010000')
End;

End.
