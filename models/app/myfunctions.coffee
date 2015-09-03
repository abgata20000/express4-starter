MyFunctions =
  # ログの出力
  log: (msg) ->
    console.log "==============================================================="
    console.log msg
  # 丸め処理
  roundString: (str, len = 20, replace_str = '...') ->
    unless str
      return ''
    ret = str.trim()
    if ret.length > len
      ret = ret.substr(0, len)
      ret += replace_str

    return ret
  # null または empty の場合は true を返す
  is_blank: (val) ->
    ret = false
    unless val
      ret = true
    else if val is ''
      ret = true

    return ret

module.exports = MyFunctions
