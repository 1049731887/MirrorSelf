<script setup>
import { onMounted, ref } from "vue";
import { postMeal } from "./api.js";
import { useMessage } from "naive-ui";

defineProps({
  msg: String,
});

const message = useMessage();
const meal = ref("");
const mealInput = ref("");
const mealShow = ref("");

onMounted(() => {
  meal.value = localStorage.getItem("lastMeal") || "";
});

function submit() {
  // 消息计数
  if (msgSoMany()) {
    return;
  }

  // 非空检测
  if (mealInput.value.trim() === "") {
    message.error("饿死我算了，啥都不给我吃");
    return;
  }

  console.log("Submitted meal:", mealInput.value);
  meal.value = mealInput.value;
  mealInput.value = "";
  submitMeal();
}

async function submitMeal() {
  let result = ref("");
  let subing = message.loading("提交中...", { duration: 0 });
  try {
    const res = await postMeal(meal.value);
    console.log("Server response:", res);
    result.value = res.status || "unknown";
  } catch (err) {
    result.value = "提交失败";
  }
  if (result.value == "recorded") {
    mealShow.value = meal.value;
    console.log("Meal submitted successfully");
    localStorage.setItem("lastMeal", meal.value);
    message.success("提交成功！");
  } else {
    alert("提交失败，错误信息：" + result.value);
  }
  subing.destroy();
}

let submitCount = 0;
setInterval(() => {
  submitCount--;
  if (submitCount < 0) submitCount = 0;
}, 2000);
setInterval(() => {
  submitCount = 1;
}, 60000);
function msgSoMany() {
  console.log("Submit count:", submitCount);
  if (submitCount >= 5) {
    message.warning("再玩就玩坏啦！");
    return true;
  }
  submitCount++;
  return false;
}
</script>

<template>
  <div class="submit">
    <h2 id="msg">{{ msg }}</h2>
    <input
      @keyup.enter="submit"
      v-model="mealInput"
      type="text"
      placeholder="在此处输入菜品或外卖链接"
      id="mealInput"
      style="font-family: initial"
    />
    <n-button type="primary" @click="submit" id="submitBtn">投！</n-button>

    <div class="menu">
      <span class="meal">{{ mealShow }}</span>
    </div>
  </div>
</template>

<style scoped>
.submit {
  font-size: medium;
}
/* 标题样式 */
h2#msg {
  text-align: center;
  font-size: 2em;
  color: #d8d8d8;
  margin-top: 20px;
}

/* 输入框样式 */
input#mealInput {
  width: 100%; /* 调整宽度为 100% */
  max-width: 400px; /* 设置最大宽度，防止过宽 */
  padding: 12px 20px; /* 增加内边距 */
  font-size: 1.2em;
  margin: 20px auto;
  display: block;
  border: 2px solid #ccc;
  border-radius: 5px;
  outline: none;
  box-sizing: border-box;
}

/* 输入框获取焦点时的样式 */
input#mealInput:focus {
  border-color: #007bff;
  box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
}

/* placeholder 样式 */
input#mealInput::placeholder {
  color: #aaa; /* 设置 placeholder 文字颜色 */
  font-style: italic; /* 可选：让 placeholder 文字为斜体 */
}

/* 按钮样式 */
#submitBtn {
  margin: 20px auto;
  font-size: 1.2em;
  width: 40%;
}

button#submitBtn:hover {
  background-color: #0056b3;
}

/* 菜单样式 */
.menu {
  margin-top: 30px;
  text-align: center;
}

span.meal {
  font-size: 1.5em;
  color: #333;
  font-weight: bold;
  padding: 10px;
  background-color: #bababa;
  border-radius: 10px;
  border: 1px solid #ddd;
  display: inline-block;
}
</style>
