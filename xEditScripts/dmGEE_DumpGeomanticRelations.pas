
Unit dmGEE_DumpGeomanticRelations;

Var geomanticRelations : TStringList;

Var filename : string;

Var allowAndConditions: boolean;

Function Initialize: integer;

Var csvHeader: string;
Begin
  filename := ProgramPath + 'Output\GeomanticRelationsDump.csv';
  geomanticRelations := TStringList.Create;
  csvHeader := 'EnchantmentKeyword,ItemKeyword,Modifier';
  csvHeader := csvHeader + ',Priority,FromPerk';
  geomanticRelations.Add(csvHeader);
  allowAndConditions := true;
End;

Function Finalize : integer;
Begin
  AddMessage('Saving Geomantic Relations to ' + filename);
  geomanticRelations.SaveToFile(filename);
  geomanticRelations.Free;
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
  ProcessEffectList(ElementByName(e, 'Effects'), EditorId(e));
End;

Function ProcessEffectList(e: IInterface; perkName: String): integer;

Var i: integer;
Begin
  If ElementCount(e) <= 0 Then
    Begin
      AddMessage(FullPath(e) + ' has no effects!');
      exit;
    End;

  For i := 0 To ElementCount(e) - 1 Do
    Begin
      ProcessEffect(ElementByIndex(e, i), perkName)
    End;
End;

Function ProcessEffect(e: IInterface; perkName: String): integer;

Var 
  modVal: string;
  priorityVal: string;
Begin
  If GetElementEditValues(e, 'PRKE - Header\Type') <> 'Entry Point' Then
    Begin
      AddMessage(FullPath(e) + ' is not an Entry Point effect!');
      exit;
    End;
  If GetElementEditValues(e, 'DATA - Effect Data\Entry Point\Entry Point') <>
     'Mod Enchantment Power' Then
    Begin
      AddMessage(FullPath(e) + ' is not an Mod Enchantment Power effect!');
      exit;
    End;
  If GetElementEditValues(e, 'DATA - Effect Data\Entry Point\Function') <>
     'Multiply Value' Then
    Begin
      AddMessage(FullPath(e) + ' is not an Multiply Value effect!');
      exit;
    End;

  modVal := GetElementEditValues(e, 'Function Parameters\EPFD - DATA\Float');
  priorityVal := GetElementEditValues(e, 'PRKE - Header\Priority');
  ProcessPerkConditionsList(ElementByName(e, 'Perk Conditions'), modVal,
  priorityVal, perkName);
End;

Function ProcessPerkConditionsList(e: IInterface; modVal: String; priorityVal:
                                   String; perkName: String): integer;

Var 
  i: integer;
  enchList: TStringList;
  itemList: TStringList;
  perkCondition: IInterface;
  tabIndex: string;
Begin
  If ElementCount(e) <> 2 Then
    Begin
      AddMessage(FullPath(e) + ' does not have EXACTLY 2 perk conditions!');
      exit;
    End;

  For i := 0 To ElementCount(e) - 1 Do
    Begin
      perkCondition := ElementByIndex(e, i);
      tabIndex := GetElementEditValues(perkCondition,
                  'PRKC - Run On (Tab Index)');
      If tabIndex = '1' Then
        enchList := ProcessConditionList(ElementByName(perkCondition,
                    'Conditions'))
      Else
        Begin
          If tabIndex = '2' Then
            itemList := ProcessConditionList(ElementByName(perkCondition,
                        'Conditions'))
          Else
            Begin
              AddMessage(FullPath(perkCondition) + ' have bad tab index!');
              exit;
            End;
        End;
    End;

  AddListsToRelations(enchList, itemList, modVal, priorityVal, perkName);
  enchList.Free;
  itemList.Free;
End;

Function ProcessConditionList(e: IInterface): TStringList;

Var 
  kwList: TStringList;
  i: integer;
  condList: TStringList;
  condition: IInterface;
Begin
  If ElementCount(e) = 0 Then
    Begin
      AddMessage(FullPath(e) + ' Has no conditions');
      exit;
    End;
  kwList := TStringList.Create;
  condList := TStringList.Create;
  For i := 0 To ElementCount(e) - 1 Do
    Begin
      condition := ElementByIndex(e, i);
      condList.Add(ProcessCondition(condition, i = ElementCount(e) - 1));
      If IsOrCondition(condition) And (condList.Count() = 1) Then
        Begin
          kwList.Add(JoinComplexCondition(condList));
          condList.Free;
          condList := TStringList.Create;
        End;
    End;
  If condList.Count() > 0 Then
    Begin
      kwList.Add(JoinComplexCondition(condList));
      condList.Free;
    End;
  Result := kwList;
End;

Function ProcessCondition(e: IInterface; isLast: boolean): string;

Var 
  conditionType: string;
  keyword: string;
Begin
  If GetElementEditValues(e, 'CTDA - CTDA\Comparison Value - Float') <>
     '1.000000' Then
    Begin
      AddMessage(FullPath(e) + ' Comparison Value is not 1.000000!');
      exit;
    End;
  If GetElementEditValues(e, 'CTDA - CTDA\Function') <> 'HasKeyword' Then
    Begin
      AddMessage(FullPath(e) + ' Function is not HasKeyword!');
      exit;
    End;
  If GetElementEditValues(e, 'CTDA - CTDA\Run On') <> 'Subject' Then
    Begin
      AddMessage(FullPath(e) + ' Run On is not Subject!');
      exit;
    End;
  If GetElementEditValues(e, 'CTDA - CTDA\Parameter #3') <> '-1' Then
    Begin
      AddMessage(FullPath(e) + ' Parameter #3 is not -1!');
      exit;
    End;

  conditionType := GetElementEditValues(e, 'CTDA - CTDA\Type');
  If (conditionType <> '10010000') And (conditionType <> '10000000') Then
    Begin
      AddMessage(FullPath(e) + ' Condition type is bad');
      exit;
    End;
  If (conditionType = '10000000') And Not allowAndConditions Then
    Begin
      AddMessage(FullPath(e) + ' Condition type AND is not allowed');
    End;

  keyword := EditorId(LinksTo(ElementByPath(e, 'CTDA - CTDA\Keyword')));
  If Not Assigned(keyword) Or (keyword = '') Then
    Begin
      AddMessage(FullPath(e) + ' No Keyword');
      exit;
    End;

  Result := keyword;
End;

Function IsOrCondition(e: IInterface): boolean;
Begin
  Result := GetElementEditValues(e, 'CTDA - CTDA\Type') = '10010000';
End;

Function JoinComplexCondition(condList: TStringList): string;

Var 
  res: string;
  i: integer;
Begin
  If (condList.Count() = 0) Then
    Begin
      Result := '';
      exit;
    End;
  If (condList.Count() = 1) Then
    Begin
      Result := condList[0];
      exit;
    End;
  res := condList[0];
  For i := 1 To condList.Count() - 1 Do
    res := res + ' & ' + condList[i];
  Result := '[' + res + ']';
End;

Function AddListsToRelations(enchList: TStringList;
                             itemList: TStringList;
                             modVal: String;
                             priorityVal: String;
                             perkName: String): integer;

Var 
  i: integer;
  j: integer;
Begin
  If (enchList.Count() = 0) Or (itemList.Count() = 0) Then
    Begin
      AddMessage('enchList is empty or itemList is empty');
      exit;
    End;
  For i := 0 To enchList.Count() -1 Do
    For j := 0 To itemList.Count() -1 Do
      geomanticRelations.Add(enchList[i] + ',' + itemList[j] + ',' + modVal +','
                             + priorityVal + ',' + perkName);
End;

End.
