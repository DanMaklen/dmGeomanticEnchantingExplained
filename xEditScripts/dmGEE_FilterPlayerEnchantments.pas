
Unit dmGEE_FilterPlayerEnchantments;

Function Filter(e: IInterface): Boolean;
Begin
  // If IsArmorOrWeapon(e) Then
  //   Begin
  //     Result := true;
  //     exit;
  //   End;
  If Signature(e) <> 'ENCH' Then    // 1688
    Begin
      Result := false;
      exit;
    End;

  If Not IsBaseEnchantment(e) Then // 685
    Begin
      Result := false;
      exit;
    End;

  If Not IsEnchantTypeEnchantment(e) Then // 572
    Begin
      Result := false;
      exit;
    End;

  If Not IsOptainable(e) Then // 236
    Begin
      Result := false;
      exit;
    End;
  Result := true;
End;

Function IsBaseEnchantment(e: IInterface): Boolean;

Var base: IInterface;
Begin
  base := LinksTo(ElementByPath(e, 'ENIT - Effect Data\Base Enchantment'));
  If FormId(base) = FormId(e) Then
    Begin
      Result := true;
      exit;
    End;
  If FormId(base) = 0 Then
    Begin
      Result := true;
      exit;
    End;
  Result := false;
End;

Function IsEnchantTypeEnchantment(e: IInterface): Boolean;
Begin
  Result := GetElementEditValues(e, 'ENIT - Effect Data\Enchant Type') =
            'Enchantment';
End;

Function IsOptainable(e: IInterface): Boolean;

Var 
  i: integer;
  child: IInterface;
Begin
  If ReferencedByCount(e) = 0 Then
    Begin
      Result := false;
      exit;
    End;
  For i := 0 To ReferencedByCount(e) - 1 Do
    Begin
      child := ReferencedByIndex(e, i);
      If FormId(e) <> FormId(child) Then
        Begin
          If (Signature(child) = 'ENCH') Then
            If IsOptainable(child) Then
              Begin
                Result := true;
                exit;
              End;
          If IsArmorOrWeapon(child) Then
            If Not HasKeyword(child, 'MagicDisallowEnchanting') Then
              Begin
                Result := true;
                exit;
              End;
        End;
    End;
  Result := false;
End;

Function HasKeyword(e: IInterface; keyword: String): Boolean;

Var 
  i: integer;
  keywordList: IInterface;
  keywordItem: IInterface;
Begin
  keywordList := ElementByName(e, 'KWDA - Keywords');
  If ElementCount(keywordList) = 0 Then
    Begin
      Result := false;
      exit;
    End;
  For i := 0 To ElementCount(keywordList) Do
    Begin
      keywordItem := LinksTo(ElementByIndex(keywordList, i));
      If EditorId(keywordItem) = keyword Then
        Begin
          Result := true;
          exit;
        End;
    End;
  Result := false;

End;

Function IsArmorOrWeapon(e: IInterface): Boolean;
Begin
  Result := (Signature(e) = 'WEAP') Or (Signature(e) = 'ARMO');
End;

Function Initialize: Integer;
Begin
  Result := 1;

  FilterConflictAll := False;
  FilterConflictThis := False;
  FilterByInjectStatus := False;
  FilterInjectStatus := False;
  FilterByNotReachableStatus := False;
  FilterNotReachableStatus := False;
  FilterByReferencesInjectedStatus := False;
  FilterReferencesInjectedStatus := False;
  FilterByEditorID := False;
  FilterEditorID := '';
  FilterByName := False;
  FilterName := '';
  FilterByBaseEditorID := False;
  FilterBaseEditorID := '';
  FilterByBaseName := False;
  FilterBaseName := '';
  FilterScaledActors := False;
  FilterByPersistent := False;
  FilterPersistent := False;
  FilterUnnecessaryPersistent := False;
  FilterMasterIsTemporary := False;
  FilterIsMaster := False;
  FilterPersistentPosChanged := False;
  FilterDeleted := False;
  FilterByVWD := False;
  FilterVWD := False;
  FilterByHasVWDMesh := False;
  FilterHasVWDMesh := False;
  FilterBySignature := False;
  FilterSignatures := '';
  FilterByBaseSignature := False;
  FilterBaseSignatures := '';
  FlattenBlocks := False;
  FlattenCellChilds := False;
  AssignPersWrldChild := False;
  InheritConflictByParent := False;
  FilterScripted := True;
  // use custom Filter() function

  ApplyFilter;
End;

End.
